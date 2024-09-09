import FluentPostgresDriver
import Vapor

struct SignUpUserController: RouteCollection, Sendable {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: SignUpUserRepositoryProtocol
    private let security: SecurityProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: SignUpUserRepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
        
        security = dependencyProvider.getSecurityInstance()
    }

    func boot(routes: RoutesBuilder) throws {
        let signUpRoutes = routes.grouped(Routes.signup.path)
        
        signUpRoutes.post(use: signup)
    }

    @Sendable
    func signup(req: Request) async throws -> GenericMessageResponse {
        var model: SignUpUserRequest = try convertRequestDataToModel(req: req)

        guard try await repository.getUserId(with: model.email) == nil else {
            throw Abort(.conflict, reason: APIErrorMessage.Credentials.userAlreadyRegistered)
        }

        if !security.areCredentialsValid(email: model.email, password: model.password) {
            throw Abort(.badRequest, reason: APIErrorMessage.Credentials.invalidCredentials)
        }
        
        model.password = try security.hashStringValue(model.password)
        try await repository.createUser(with: User(from: model))
        return GenericMessageResponse(message: Constants.welcomeMessage)
    }

    enum Constants {
        static let welcomeMessage = "Account created with success"
    }
}
