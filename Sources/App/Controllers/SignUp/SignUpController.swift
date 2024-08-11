import Vapor

struct SignUpController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let signUpRoutes = routes.grouped("signUp")
        signUpRoutes.post(use: signUp)
    }

    @Sendable
    func signUp(req: Request) async throws -> String {
        "Sign up"
    }
}
