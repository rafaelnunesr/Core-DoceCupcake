import FluentPostgresDriver
import Vapor

protocol SignInRepositoryProtocol: Sendable {
    func fetchUserByEmail(_ email: String) async throws -> User?
    func fetchAdminByEmail(_ email: String) async throws -> Admin?
}

final class SignInRepository: SignInRepositoryProtocol {
    private let database: Database

    init(database: Database) {
        self.database = database
    }
    
    func fetchUserByEmail(_ email: String) async throws -> User? {
        try await User.query(on: database)
            .filter(\.$email == email)
            .first()
    }
    
    func fetchAdminByEmail(_ email: String) async throws -> Admin? {
        try await Admin.query(on: database)
            .filter(\.$email == email)
            .first()
    }
}
