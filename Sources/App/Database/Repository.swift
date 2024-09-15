import FluentPostgresDriver
import Vapor

protocol RepositoryProtocol: Sendable {
    func fetchAllResults<T: DatabaseModelProtocol>() async throws -> [T]
    func fetchModelById<T: DatabaseModelProtocol>(_ id: UUID) async throws -> T?
    func fetchModelByCode<T: DatabaseModelProtocol>(_ code: String) async throws -> T?
    func create<T: DatabaseModelProtocol>(_ model: T) async throws
    func update<T: DatabaseModelProtocol>(_ model: T) async throws
    func delete<T: DatabaseModelProtocol>(_ model: T) async throws
}

final class Repository: RepositoryProtocol {
    private let database: Database

    init(database: Database) {
        self.database = database
    }

    func fetchAllResults<T: DatabaseModelProtocol>() async throws -> [T] {
        try await T.query(on: database)
            .all()
    }

    func fetchModelById<T: DatabaseModelProtocol>(_ id: UUID) async throws -> T? {
        try await T.query(on: database)
            .filter(T.idKey == id)
            .first()
    }

    func fetchModelByCode<T: DatabaseModelProtocol>(_ code: String) async throws -> T? {
        try await T.query(on: database)
            .filter(T.codeKey == code)
            .first()
    }

    func create<T: DatabaseModelProtocol>(_ model: T) async throws {
        try await model.create(on: database)
    }
    
    func update<T: DatabaseModelProtocol>(_ model: T) async throws {
        try await model.update(on: database)
    }

    func delete<T: DatabaseModelProtocol>(_ model: T) async throws {
        try await model.delete(on: database)
    }
}
