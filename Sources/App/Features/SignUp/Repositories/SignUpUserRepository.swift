import FluentPostgresDriver
import Vapor

protocol SignUpUserRepositoryProtocol {
    func getUserId(with email: String) async throws -> UUID?
    func createUser(with user: User) async throws
}

final class SignUpUserRepository: SignUpUserRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }

    func getUserId(with email: String) async throws -> UUID? {
        try await User.query(on: database)
            .filter(\.$email == email)
            .first()?.id
    }

    func createUser(with user: User) async throws {
        try await user.create(on: database)
    }
}
