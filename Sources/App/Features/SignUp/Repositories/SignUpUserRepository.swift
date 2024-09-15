import FluentPostgresDriver
import Vapor

protocol SignUpUserRepositoryProtocol: Sendable {
    func fetchUserId(with email: String) async throws -> UUID?
    func create(with user: User) async throws -> UUID
}

final class SignUpUserRepository: SignUpUserRepositoryProtocol {
    private let database: Database

    init(database: Database) {
        self.database = database
    }

    func fetchUserId(with email: String) async throws -> UUID? {
        try await User.query(on: database)
            .filter(\.$email == email)
            .first()?.id
    }

    func create(with user: User) async throws -> UUID {
        try await user.create(on: database)
        return try user.requireID()
    }
}
