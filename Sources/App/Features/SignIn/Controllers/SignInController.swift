import FluentPostgresDriver
import Foundation
import Vapor

struct SignInController: RouteCollection {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: SignInRepositoryProtocol
    private let sectionController: SectionControllerProtocol

    init(dependencyProvider: DependencyProviderProtocol, 
         repository: SignInRepositoryProtocol,
         sectionController: SectionController) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
        self.sectionController = sectionController
    }

    func boot(routes: RoutesBuilder) throws {
        let signInRoutes = routes.grouped("signIn")
        signInRoutes.post(use: signIn)
    }

    func signIn(req: Request) async throws -> ClientTokenResponse {
        let model: APISignInModel = try convertRequestDataToModel(req: req)

        guard let userId = try await getUserId(model) else {
            throw Abort(.unauthorized, reason: APIErrorMessage.Credentials.invalidCredentials)
        }

        return try await createSectionForUser(userId: userId, req: req)
    }

    private func getUserId(_ model: APISignInModel) async throws -> UUID? {
        guard let user = try await repository.getUser(with: model.email),
              user.password == model.password else {
            return nil
        }

        return user.id
    }

    private func createSectionForUser(userId: UUID, req: Request) async throws -> ClientTokenResponse {
        guard let section = try await sectionController.createSection(for: userId, isAdmin: false, req: req) else {
            fatalError()
        }
        return ClientTokenResponse(token: section.token)
    }
}
