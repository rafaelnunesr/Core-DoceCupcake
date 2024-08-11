import Vapor

struct SignInController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let signInRoutes = routes.grouped("signIn")
        signInRoutes.get(use: signIn)
    }

    @Sendable
    func signIn(req: Request) async throws -> SectionModel {
        SectionModel(userId: .empty, token: .empty)
    }
}
