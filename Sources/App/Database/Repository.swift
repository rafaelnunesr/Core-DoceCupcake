import FluentPostgresDriver
import Vapor

protocol RepositoryProtocol {
    func getAllResults<T: DatabaseModelProtocol>() async throws -> [T]
    func getModelById<T: DatabaseModelProtocol>(_ id: UUID) async throws -> T?
    func getModelByCode<T: DatabaseModelProtocol>(_ code: String) async throws -> T?
    func create<T: DatabaseModelProtocol>(_ model: T) async throws
    func delete<T: DatabaseModelProtocol>(_ model: T) async throws
}

final class Repository: RepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }

    func getAllResults<T: DatabaseModelProtocol>() async throws -> [T] {
        try await T.query(on: database)
            .all()
    }

    func getModelById<T: DatabaseModelProtocol>(_ id: UUID) async throws -> T? {
        try await T.query(on: database)
            .filter(T.idKey == id)
            .first()
    }

    func getModelByCode<T: DatabaseModelProtocol>(_ code: String) async throws -> T? {
        try await T.query(on: database)
            .filter(T.codeKey == code)
            .first()
    }

    func create<T: DatabaseModelProtocol>(_ model: T) async throws {
        try await model.create(on: database)
    }

    func delete<T: DatabaseModelProtocol>(_ model: T) async throws {
        try await model.delete(on: database)
    }
}
