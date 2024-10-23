import Vapor

@testable import App

final class MockSessionController: SessionControllerProtocol {
    var session: InternalSessionModel?
    var sessionResult = SessionControlAccess.unowned
    
    func boot(routes: RoutesBuilder) throws {}
    
    func create(for userId: UUID, isAdmin: Bool, req: Request) async throws -> InternalSessionModel? {
        return session
    }
    
    func validateSession(req: Vapor.Request) async throws -> SessionControlAccess {
        sessionResult
    }
    
    func delete(for userId: UUID) async throws {
        session = nil
    }
    
    func fetchLoggedUserId(req: Vapor.Request) async throws -> UUID {
        session?.userId ?? UUID()
    }
    
    func fetchLoggedUserName(req: Request) async throws -> String {
        "John Snow"
    }
}
