import Vapor

@testable import App

final class MockSectionController: SessionControllerProtocol {
    var section: InternalSessionModel?

    func createSection(for userId: UUID, isAdmin: Bool, req: Request) async throws -> InternalSessionModel? {
        return section
    }
    
    func validateSection(req: Vapor.Request) async throws -> App.SessionControlAccess {
        fatalError()
    }
    
    func deleteSection(for userId: UUID) async throws {
        fatalError()
    }
}
