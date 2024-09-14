import FluentPostgresDriver
import Vapor

protocol SignUpAdminRepositoryProtocol: Sendable {
    func fetchUserId(with email: String) async throws -> UUID?
    func create(with admin: Admin) async throws
}

final class SignUpAdminRepository: SignUpAdminRepositoryProtocol {
    private let database: Database

    init(database: Database) {
        self.database = database
    }

    func fetchUserId(with email: String) async throws -> UUID? {
        try await Admin.query(on: database)
            .filter(\.$email == email)
            .first()?.id
    }

    func create(with admin: Admin) async throws {
        try await admin.create(on: database)
    }
}

