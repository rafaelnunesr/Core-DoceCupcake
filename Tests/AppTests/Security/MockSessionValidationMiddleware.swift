import Vapor

@testable import App

struct MockSessionValidationMiddleware: SessionValidationMiddlewareProtocol {
    var responseStatus: ResponseStatus = .success
    
    enum ResponseStatus {
        case unauthorized
        case success
    }
    
    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        switch responseStatus {
        case .unauthorized:
            throw Abort(.unauthorized, reason: .empty)
        case .success:
            return try await next.respond(to: req)
        }
    }
}

