import Vapor

protocol AdminValidationMiddlewareProtocol: AsyncMiddleware {
    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response
}

struct AdminValidationMiddleware: AdminValidationMiddlewareProtocol {
    private let sectionController: SectionControllerProtocol

    init(sectionController: SectionControllerProtocol) {
        self.sectionController = sectionController
    }

    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard try await sectionController.validateSection(req: req) == .admin else {
            throw Abort(.unauthorized, reason: APIErrorMessage.Common.unauthorized)
        }

        return try await next.respond(to: req)
    }
}
