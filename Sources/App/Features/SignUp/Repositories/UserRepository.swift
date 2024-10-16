import FluentPostgresDriver
import Vapor

protocol UserRepositoryProtocol: Sendable {
    func fetchUserId(with email: String) async throws -> UUID?
    func fetchUser(with id: UUID) async throws -> User?
    func create(with user: User) async throws -> UUID
}

final class UserRepository: UserRepositoryProtocol {
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
    
    func fetchUser(with id: UUID) async throws -> User? {
        try await User.query(on: database)
            .filter(\.$id == id)
            .first()
    }
}
