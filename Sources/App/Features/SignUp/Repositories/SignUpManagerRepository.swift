import FluentPostgresDriver
import Vapor

protocol SignUpManagerRepositoryProtocol {
    func getUserId(with email: String) async throws -> UUID?
    func createUser(with manager: Manager) async throws
}

final class SignUpManagerRepository: SignUpManagerRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }

    func getUserId(with email: String) async throws -> UUID? {
        try await Manager.query(on: database)
            .filter(\.$email == email)
            .first()?.id
    }

    func createUser(with manager: Manager) async throws {
        try await manager.create(on: database)
    }
}

