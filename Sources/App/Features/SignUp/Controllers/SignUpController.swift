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
    func signUp(req: Request) async throws -> APICreateUserResponse {
        guard let bodyData = req.body.data else {
            throw Abort(.badRequest, reason: APIErrorMessage.Common.badRequest)
        }
        let model = try JSONDecoder().decode(APISignUpModel.self, from: bodyData)

        let userId = try await repository.getUserId(with: model.email)

        guard userId == nil else {
            throw Abort(.conflict, reason: APIErrorMessage.Credentials.userAlreadyRegistered)
        }

        if !areCredentialsValid(model) {
            throw Abort(.badRequest, reason: APIErrorMessage.Credentials.invalidCredentials)
        }
        
        let newUser = User(from: model)

        return APICreateUserResponse(message: "Welcome")
    }

    private func areCredentialsValid(_ model: APISignUpModel) -> Bool {
        model.email.isValidEmail && model.password.isValidPassword
    }
}
