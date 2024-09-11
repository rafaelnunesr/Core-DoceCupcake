import Vapor

final class ErrorHandlingMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        do {
            return try await next.respond(to: request)
        } catch let abortError as Abort {
            switch abortError.status {
            case .badRequest, .unauthorized, .notFound, .conflict, .internalServerError:
                return Response(status: abortError.status)
            default:
                return Response(status: .internalServerError)
            }
        } catch {
            return Response(status: .internalServerError)
        }
    }
}
