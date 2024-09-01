import FluentPostgresDriver
import Vapor

struct SignUpAdminController: RouteCollection {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: SignUpManagerRepositoryProtocol
    private let security: SecurityProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: SignUpManagerRepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
        
        security = dependencyProvider.getSecurityInstance()
    }

    func boot(routes: RoutesBuilder) throws {
        let signUpRoutes = routes.grouped("admin")
        signUpRoutes.post(use: signUp)
    }

    func signUp(req: Request) async throws -> APIGenericMessageResponse {
        var model: APISignUpAdminModel = try convertRequestDataToModel(req: req)

        guard try await repository.getUserId(with: model.email) == nil else {
            throw Abort(.conflict, reason: APIErrorMessage.Credentials.userAlreadyRegistered)
        }

        if !security.areCredentialsValid(email: model.email, password: model.password) {
            throw Abort(.badRequest, reason: APIErrorMessage.Credentials.invalidCredentials)
        }

        model.password = try security.hashStringValue(model.password)
        try await repository.createUser(with: Admin(from: model))
        return APIGenericMessageResponse(message: Constants.welcomeMessage)
    }

    private enum Constants {
        static let welcomeMessage = "Admin created with success."
    }
}
