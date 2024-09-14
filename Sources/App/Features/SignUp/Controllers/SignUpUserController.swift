import FluentPostgresDriver
import Vapor

struct SignUpUserController: RouteCollection, Sendable {
    private let repository: SignUpUserRepositoryProtocol
    private let security: SecurityProtocol
    private let addressController: AddressControllerProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: SignUpUserRepositoryProtocol,
         addressController: AddressControllerProtocol) {
        self.repository = repository
        self.addressController = addressController
        security = dependencyProvider.getSecurityInstance()
    }

    func boot(routes: RoutesBuilder) throws {
        let signUpRoutes = routes.grouped(PathRoutes.signup.path)
        signUpRoutes.post(use: signup)
    }

    @Sendable
    func signup(req: Request) async throws -> GenericMessageResponse {
        var model: SignUpUserRequest = try convertRequestDataToModel(req: req)

        try await validateUserUniqueness(email: model.email)
        try await validateCredentials(email: model.email, password: model.password)
        
        model.password = try security.hashStringValue(model.password)
        let user = User(from: model)
        
        guard let userId = user.id
        else { throw APIResponseError.Common.internalServerError }
        
        try await repository.create(with: User(from: model))
        
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
                              number: model.streetName,
                              zipCode: model.zipCode,
                              state: model.state,
                              city: model.city,
                              country: model.country)
        
        try await addressController.create(address)
    }

    private func accountCreationMessage(userName: String) -> String {
        "The account for \(userName) has been successfully created."
    }
}
