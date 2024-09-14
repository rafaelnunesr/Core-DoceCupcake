import FluentPostgresDriver
import Vapor

struct SignUpAdminController: RouteCollection, Sendable {
    private let repository: SignUpAdminRepositoryProtocol
    private let security: SecurityProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: SignUpAdminRepositoryProtocol) {
        self.repository = repository
        security = dependencyProvider.getSecurityInstance()
    }

    func boot(routes: RoutesBuilder) throws {
        let signUpRoutes = routes.grouped(PathRoutes.admin.path)
        signUpRoutes.post(use: signup)
    }

    @Sendable
    func signup(req: Request) async throws -> GenericMessageResponse {
        var model: SignUpAdminRequest = try convertRequestDataToModel(req: req)
        try await validateUserUniqueness(email: model.email)
        try await validateCredentials(email: model.email, password: model.password)
        
        model.password = try security.hashStringValue(model.password)
        try await repository.create(with: Admin(from: model))
        return GenericMessageResponse(message: accountCreationMessage(userName: model.userName))
    }
    
    private func validateUserUniqueness(email: String) async throws {
        guard try await repository.fetchUserId(with: email) == nil else {
            throw APIResponseError.Signup.conflict
        }
    }
    
    private func validateCredentials(email: String, password: String) async throws {
        guard security.areCredentialsValid(email: email, password: password)
        else { throw APIResponseError.Signup.unauthorized }
    }
    
    private func accountCreationMessage(userName: String) -> String {
        "The admin account for \(userName) has been successfully created."
    }
}

