import FluentPostgresDriver
import Vapor

protocol NutritionalRepositoryProtocol {
    func getNutritionalById(_ id: UUID) async throws -> InternalNutritionalModel?
    func getNutritionalByAllFields(_ model: InternalNutritionalModel) async throws -> InternalNutritionalModel?
    func saveNutritionalModel(_ model: InternalNutritionalModel) async throws
    func deleteNutritionalModel(_ model: InternalNutritionalModel) async throws
}

final class NutritionalRepository: NutritionalRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }

    func getNutritionalById(_ id: UUID) async throws -> InternalNutritionalModel? {
        try await InternalNutritionalModel.query(on: database)
            .filter(\.$id == id)
            .first()
    }

    func getNutritionalByAllFields(_ model: InternalNutritionalModel) async throws -> InternalNutritionalModel? {
        try await InternalNutritionalModel.query(on: database)
            .filter(\.$name == model.name)
            .filter(\.$quantityDescription == model.quantityDescription)
            .filter(\.$dailyRepresentation == model.dailyRepresentation)
            .first()
    }

    func saveNutritionalModel(_ model: InternalNutritionalModel) async throws {
        try await model.create(on: database)
    }

    func deleteNutritionalModel(_ model: InternalNutritionalModel) async throws {
        try await model.delete(on: database)
    }
}
