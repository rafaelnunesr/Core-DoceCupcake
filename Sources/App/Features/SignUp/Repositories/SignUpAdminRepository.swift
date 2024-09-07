import FluentPostgresDriver
import Vapor

protocol SignUpAdminRepositoryProtocol: Sendable {
    func getUserId(with email: String) async throws -> UUID?
    func createUser(with manager: Admin) async throws
}

final class SignUpAdminRepository: SignUpAdminRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }

    func getUserId(with email: String) async throws -> UUID? {
        try await Admin.query(on: database)
            .filter(\.$email == email)
            .first()?.id
    }

    func createUser(with manager: Admin) async throws {
        try await manager.create(on: database)
    }
}

