import Foundation

@testable import App

final class MockSessionRepository: SessionRepositoryProtocol {
    var result: InternalSessionModel?
    
    func getSection(for usertId: UUID) async throws -> InternalSessionModel? {
        result
    }
    
    func getSection(with token: String) async throws -> InternalSessionModel? {
        result
    }

    func createSection(for model: InternalSessionModel) async throws {
        result = model
    }

    func deleteSection(for section: InternalSessionModel) async throws {
        result = nil
    }
}
