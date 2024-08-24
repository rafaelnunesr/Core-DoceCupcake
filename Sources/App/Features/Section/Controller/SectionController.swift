import FluentPostgresDriver
import Foundation
import Vapor

protocol SectionControllerProtocol {
    func getSection(for userId: UUID) async throws -> InternalSectionModel?
    func createSection(for userId: UUID) async throws -> InternalSectionModel
    func deleteSection(for userId: UUID) async throws
}

struct SectionController: SectionControllerProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: SectionRepositoryProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: SectionRepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
    }

    func getSection(for userId: UUID) async throws -> InternalSectionModel? {
        try await repository.getSection(for: userId)
    }

    func createSection(for userId: UUID) async throws -> InternalSectionModel {
        try await repository.createSection(for: userId)
    }

    func deleteSection(for userId: UUID) async throws {
        guard let section = try await repository.getSection(for: userId) else {
            return
        }

        try await repository.deleteSection(for: section)
    }
}
