import FluentPostgresDriver
import Vapor

protocol SignInRepositoryProtocol {
    func getUser(with email: String) async throws -> User?
    func createSection(for userId: UUID) async throws -> InternalSectionModel
}

final class SignInRepository: SignInRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }

    func getUser(with email: String) async throws -> User? {
        try await User.query(on: database)
            .filter(\.$email == email)
                .first()
    }

    func createSection(for userId: UUID) async throws -> InternalSectionModel {
        if let previousSection = try await getSectionForUser(with: userId) {
            try await deleteSection(for: previousSection)
        }

        let sectionToken = getSectionToken()
        let sectionModel = InternalSectionModel(userId: userId, token: sectionToken, isManager: false) // change this
        try await sectionModel.create(on: database)

        return sectionModel
    }

    private func deleteSection(for section: InternalSectionModel) async throws {
        try await section.delete(on: database)
    }

    private func getSectionForUser(with userId: UUID) async throws -> InternalSectionModel? {
        return try await InternalSectionModel.query(on: database)
            .filter(\.$userId == userId)
            .first()
    }

    private func getSectionToken() -> String {
        let sectionTokenGenerator = dependencyProvider.getSectionTokenGeneratorInstance()
        return sectionTokenGenerator.getToken()
    }
}
