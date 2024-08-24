import FluentPostgresDriver
import Vapor

protocol SectionRepositoryProtocol {
    func getSection(for userId: UUID) async throws -> InternalSectionModel?
    func createSection(for userId: UUID) async throws -> InternalSectionModel
    func deleteSection(for section: InternalSectionModel) async throws
}

final class SectionRepository: SectionRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }

    func getSection(for userId: UUID) async throws -> InternalSectionModel? {
        return try await InternalSectionModel.query(on: database)
            .filter(\.$userId == userId)
            .first()
    }

    func createSection(for userId: UUID) async throws -> InternalSectionModel {
        if let previousSection = try await getSection(for: userId) {
            try await deleteSection(for: previousSection)
        }

        let sectionToken = "" // todo
        let sectionModel = InternalSectionModel(userId: userId, token: sectionToken, isManager: false) // change this
        try await sectionModel.create(on: database)

        return sectionModel
    }

    func deleteSection(for section: InternalSectionModel) async throws {
        try await section.delete(on: database)
    }
}
