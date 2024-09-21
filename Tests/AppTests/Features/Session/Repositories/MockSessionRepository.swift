import Foundation

@testable import App

final class MockSessionRepository: SessionRepositoryProtocol {
    var result: InternalSessionModel?
    
    func fetchSession(for usertId: UUID) async throws -> InternalSessionModel? {
        result
    }
    
    func fetchSession(with token: String) async throws -> InternalSessionModel? {
        result
    }

    func create(for model: InternalSessionModel) async throws {
        result = model
    }

    func delete(for session: InternalSessionModel) async throws {
        result = nil
    }
}
