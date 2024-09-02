import FluentPostgresDriver
import Vapor

protocol NutritionalRepositoryProtocol: RepositoryProtocol {
    func getNutritionalByAllFields(_ model: NutritionalInformation) async throws -> NutritionalInformation?
}

final class NutritionalRepository: NutritionalRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }

    func getNutritionalByAllFields(_ model: NutritionalInformation) async throws -> NutritionalInformation? {
        try await NutritionalInformation.query(on: database)
            .filter(\.$name == model.name)
            .filter(\.$quantityDescription == model.quantityDescription)
            .filter(\.$dailyRepresentation == model.dailyRepresentation)
            .first()
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

    func delete<T: DatabaseModelProtocol>(_ model: T) async throws {
        try await model.delete(on: database)
    }
}
