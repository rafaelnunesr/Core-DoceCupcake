import Vapor

struct UserController: RouteCollection, Sendable {
    private let repository: UserRepositoryProtocol
    private let addressController: AddressControllerProtocol
    private let security: SecurityProtocol
    private let sessionController: SessionControllerProtocol
    
    private let sessionValidation: SessionValidationMiddlewareProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: UserRepositoryProtocol,
         addressController: AddressControllerProtocol,
         sessionController: SessionControllerProtocol) {
        self.repository = repository
        self.addressController = addressController
        self.sessionController = sessionController
        
        security = dependencyProvider.getSecurityInstance()
        
        sessionValidation = dependencyProvider.getUserSessionValidationMiddleware()
    }

    func boot(routes: RoutesBuilder) throws {
        let signUpRoutes = routes.grouped(PathRoutes.userInfo.path)
        
        signUpRoutes
            .grouped(sessionValidation)
            .get(use: fetchUserInfo)
        
        signUpRoutes
            .grouped(sessionValidation)
            .put(use: update)
    }
    
    @Sendable
    func fetchUserInfo(req: Request) async throws -> APIUserInformation {
        let userId = try await sessionController.fetchLoggedUserId(req: req)
        let address = try await addressController.fetchAddressByUserId(userId)
        
        let user = try await repository.fetchUser(with: userId)
        
        guard let user, let address else {
            throw APIResponseError.Common.internalServerError
        }
        
        return APIUserInformation(from: user, address: address)
    }

    @Sendable
    func update(req: Request) async throws -> GenericMessageResponse {
        var model: SignUpUserRequest = try convertRequestDataToModel(req: req)

        try await validateUserUniqueness(email: model.email)
        try await validateCredentials(email: model.email, password: model.password)
        
        model.password = try security.hashStringValue(model.password)
        let userId = try await repository.create(with: User(from: model))
        
        try await saveUserAddress(model, userId: userId)
        return GenericMessageResponse(message: accountCreationMessage(userName: model.userName))
    }
    
    private func validateUserUniqueness(email: String) async throws {
        guard try await repository.fetchUserId(with: email) == nil
        else { throw APIResponseError.Signup.conflict }
    }
    
    private func validateCredentials(email: String, password: String) async throws {
        guard security.areCredentialsValid(email: email, password: password)
        else { throw APIResponseError.Signup.unauthorized }
    }
    
    private func saveUserAddress(_ model: SignUpUserRequest, userId: UUID) async throws {
        let address = Address(userId: userId,
                              streetName: model.streetName,
                              number: model.addressNumber,
                              zipCode: model.zipCode,
                              complementary: model.addressComplement,
                              state: model.state,
                              city: model.city,
                              country: model.country)
        
        try await addressController.create(address)
    }

    private func accountCreationMessage(userName: String) -> String {
        "The account for \(userName) has been successfully created."
    }
}
