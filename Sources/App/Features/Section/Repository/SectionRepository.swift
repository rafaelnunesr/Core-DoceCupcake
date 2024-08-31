import FluentPostgresDriver
import Vapor

protocol SectionRepositoryProtocol {
    func getSection(for usertId: UUID) async throws -> InternalSectionModel?
    func getSection(with token: String) async throws -> InternalSectionModel?
    func createSection(for model: InternalSectionModel) async throws
    func deleteSection(for section: InternalSectionModel) async throws
}

final class SectionRepository: SectionRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }
    
    func getSection(for usertId: UUID) async throws -> InternalSectionModel? {
        return try await InternalSectionModel.query(on: database)
            .filter(\.$userId == usertId)
            .first()
    }
    
    func getSection(with token: String) async throws -> InternalSectionModel? {
        return try await InternalSectionModel.query(on: database)
            .filter(\.$token == token)
            .first()
    }

    func createSection(for model: InternalSectionModel) async throws {
        try await model.create(on: database)
    }

    func deleteSection(for section: InternalSectionModel) async throws {
        try await section.delete(on: database)
    }
}
