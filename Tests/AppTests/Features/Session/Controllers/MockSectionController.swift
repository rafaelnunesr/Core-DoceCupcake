import Vapor

@testable import App

final class MockSectionController: SectionControllerProtocol {
    var section: InternalSectionModel?

    func createSection(for userId: UUID, isAdmin: Bool, req: Request) async throws -> InternalSectionModel? {
        return section
    }
    
    func validateSection(req: Vapor.Request) async throws -> App.SectionControlAccess {
        fatalError()
    }
    
    func deleteSection(for userId: UUID) async throws {
        fatalError()
    }
}
