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
        return try await next.respond(to: req)
        
        // undo
        guard try await sessionController.validateSession(req: req) == .admin else {
            throw Abort(.unauthorized, reason: APIErrorMessage.Common.unauthorized)
        }

        return try await next.respond(to: req)
    }
}
