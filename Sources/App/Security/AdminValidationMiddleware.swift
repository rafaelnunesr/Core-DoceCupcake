import Vapor

protocol AdminValidationMiddlewareProtocol: AsyncMiddleware {
    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response
}

struct AdminValidationMiddleware: AdminValidationMiddlewareProtocol {
    private let sessionController: SessionControllerProtocol

    init(sessionController: SessionControllerProtocol) {
        self.sessionController = sessionController
    }

    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard try await sessionController.validateSession(req: req) == .admin 
        else { throw APIResponseError.Common.unauthorized }

        return try await next.respond(to: req)
    }
}
