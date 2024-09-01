import Vapor

protocol SectionValidationMiddlewareProtocol: AsyncMiddleware {
    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response
}

struct SectionValidationMiddleware: SectionValidationMiddlewareProtocol {
    private let sectionController: SectionControllerProtocol

    init(sectionController: SectionControllerProtocol) {
        self.sectionController = sectionController
    }

    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard try await sectionController.validateSection(req: req) != .unowned else {
            throw Abort(.unauthorized, reason: APIErrorMessage.Common.unauthorized)
        }

        return try await next.respond(to: req)
    }
}
