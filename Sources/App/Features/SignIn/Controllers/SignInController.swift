import FluentPostgresDriver
import Foundation
import Vapor

struct SignInController: RouteCollection {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: SignInRepositoryProtocol

    init(dependencyProvider: DependencyProviderProtocol, 
         repository: SignInRepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
    }

    func boot(routes: RoutesBuilder) throws {
        let signInRoutes = routes.grouped("signIn")
        signInRoutes.post(use: signIn)
    }

    func signIn(req: Request) async throws -> APISectionResponse {
        let model: APISignInModel = try convertRequestDataToModel(req: req)

        guard let userId = try await getUserId(model) else {
            throw Abort(.unauthorized, reason: APIErrorMessage.Credentials.invalidCredentials)
        }

        return try await createSectionForUser(email: model.email, userId: userId)
    }

    private func getUserId(_ model: APISignInModel) async throws -> UUID? {
        guard let user = try await repository.getUser(with: model.email),
              user.password == model.password else {
            return nil
        }

        return user.id
    }

    private func createSectionForUser(email: String, userId: UUID) async throws -> APISectionResponse {
        let section = try await repository.createSection(for: userId)
        return APISectionResponse(userId: section.userId, sectionToken: section.token)
    }
}
