import FluentPostgresDriver
import Vapor

struct SignUpManagerController: RouteCollection {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: SignUpManagerRepositoryProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: SignUpManagerRepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
    }

    func boot(routes: RoutesBuilder) throws {
        let signUpRoutes = routes.grouped("signUp")
        signUpRoutes.post("/manager", use: signUp)
    }

    @Sendable
    func signUp(req: Request) async throws -> APIGenericMessageResponse {
        let model: APISignUpManagerModel = try convertRequestDataToModel(req: req)

        guard try await repository.getUserId(with: model.email) == nil else {
            throw Abort(.conflict, reason: APIErrorMessage.Credentials.userAlreadyRegistered)
        }

        if !areCredentialsValid(model) {
            throw Abort(.badRequest, reason: APIErrorMessage.Credentials.invalidCredentials)
        }

        try await repository.createUser(with: Manager(from: model))
        return APIGenericMessageResponse(message: Constants.welcomeMessage)
    }

    private func areCredentialsValid(_ model: APISignUpManagerModel) -> Bool {
        model.email.isValidEmail && model.password.isValidPassword
    }

    private enum Constants {
        static let welcomeMessage = "Account created with success."
    }
}

