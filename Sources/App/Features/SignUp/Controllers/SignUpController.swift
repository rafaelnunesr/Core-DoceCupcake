import FluentPostgresDriver
import Vapor

struct SignUpController: RouteCollection {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: SignUpRepositoryProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: SignUpRepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
    }

    func boot(routes: RoutesBuilder) throws {
        let signUpRoutes = routes.grouped("signUp")
        signUpRoutes.post(use: signUp)
    }

    @Sendable
    func signUp(req: Request) async throws -> APIGenericMessageResponse {
        let model: APISignUpModel = try convertRequestDataToModel(req: req)

        guard try await repository.getUserId(with: model.email) == nil else {
            throw Abort(.conflict, reason: APIErrorMessage.Credentials.userAlreadyRegistered)
        }

        if !areCredentialsValid(model) {
            throw Abort(.badRequest, reason: APIErrorMessage.Credentials.invalidCredentials)
        }

        try await repository.createUser(with: User(from: model))
        return APIGenericMessageResponse(message: Constants.welcomeMessage)
    }

    private func areCredentialsValid(_ model: APISignUpModel) -> Bool {
        model.email.isValidEmail && model.password.isValidPassword
    }

    private enum Constants {
        static let welcomeMessage = "Account created with success"
    }
}
