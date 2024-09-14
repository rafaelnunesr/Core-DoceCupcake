import FluentPostgresDriver
import Vapor

protocol SessionRepositoryProtocol: Sendable {
    func fetchSession(for usertId: UUID) async throws -> InternalSessionModel?
    func fetchSession(with token: String) async throws -> InternalSessionModel?
    func create(for model: InternalSessionModel) async throws
    func delete(for session: InternalSessionModel) async throws
}

final class SessionRepository: SessionRepositoryProtocol {
    private let database: Database

    init(database: Database) {
        self.database = database
    }
    
    func fetchSession(for usertId: UUID) async throws -> InternalSessionModel? {
        return try await InternalSessionModel.query(on: database)
            .filter(\.$userId == usertId)
            .first()
    }
    
    func fetchSession(with token: String) async throws -> InternalSessionModel? {
        return try await InternalSessionModel.query(on: database)
            .filter(\.$token == token)
            .first()
    }

    func create(for model: InternalSessionModel) async throws {
        try await model.create(on: database)
    }

    func delete(for session: InternalSessionModel) async throws {
        try await session.delete(on: database)
    }
}
