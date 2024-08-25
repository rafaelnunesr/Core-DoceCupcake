import FluentPostgresDriver
import Vapor

struct SignUpUserController: RouteCollection {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: SignUpUserRepositoryProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: SignUpUserRepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
    }

    func boot(routes: RoutesBuilder) throws {
        let signUpRoutes = routes.grouped("signUp")
        signUpRoutes.post(use: signUp)
    }

    @Sendable
    func signUp(req: Request) async throws -> APIGenericMessageResponse {
        let model: APISignUpUserModel = try convertRequestDataToModel(req: req)

        guard try await repository.getUserId(with: model.email) == nil else {
            throw Abort(.conflict, reason: APIErrorMessage.Credentials.userAlreadyRegistered)
        }

        if !areCredentialsValid(model) {
            throw Abort(.badRequest, reason: APIErrorMessage.Credentials.invalidCredentials)
        }

        try await repository.createUser(with: User(from: model))
        return APIGenericMessageResponse(message: Constants.welcomeMessage)
    }

    private func areCredentialsValid(_ model: APISignUpUserModel) -> Bool {
        model.email.isValidEmail && model.password.isValidPassword
    }

    private enum Constants {
        static let welcomeMessage = "Account created with success"
    }
}
