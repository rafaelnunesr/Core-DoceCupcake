import FluentPostgresDriver
import Vapor

protocol SessionRepositoryProtocol: Sendable {
    func getSession(for usertId: UUID) async throws -> InternalSessionModel?
    func getSession(with token: String) async throws -> InternalSessionModel?
    func createSession(for model: InternalSessionModel) async throws
    func deleteSession(for session: InternalSessionModel) async throws
}

final class SessionRepository: SessionRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }
    
    func getSession(for usertId: UUID) async throws -> InternalSessionModel? {
        return try await InternalSessionModel.query(on: database)
            .filter(\.$userId == usertId)
            .first()
    }
    
    func getSession(with token: String) async throws -> InternalSessionModel? {
        return try await InternalSessionModel.query(on: database)
            .filter(\.$token == token)
            .first()
    }

    func createSession(for model: InternalSessionModel) async throws {
        try await model.create(on: database)
    }

    func deleteSession(for session: InternalSessionModel) async throws {
        try await session.delete(on: database)
    }
}
