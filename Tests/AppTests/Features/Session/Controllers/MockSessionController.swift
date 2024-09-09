import Vapor

@testable import App

final class MockSessionController: SessionControllerProtocol {
    var session: InternalSessionModel?
    var sessionResult = SessionControlAccess.unowned

    func createSession(for userId: UUID, isAdmin: Bool, req: Request) async throws -> InternalSessionModel? {
        return session
    }
    
    func validateSession(req: Vapor.Request) async throws -> SessionControlAccess {
        sessionResult
    }
    
    func deleteSession(for userId: UUID) async throws {
        session = nil
    }
}
