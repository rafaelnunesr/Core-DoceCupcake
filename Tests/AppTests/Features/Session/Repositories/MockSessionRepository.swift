import Foundation

@testable import App

final class MockSessionRepository: SessionRepositoryProtocol {
    var result: InternalSessionModel?
    
    func getSession(for usertId: UUID) async throws -> InternalSessionModel? {
        result
    }
    
    func getSession(with token: String) async throws -> InternalSessionModel? {
        result
    }

    func createSession(for model: InternalSessionModel) async throws {
        result = model
    }

    func deleteSession(for session: InternalSessionModel) async throws {
        result = nil
    }
}
