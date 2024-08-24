import FluentPostgresDriver
import Foundation
import Vapor

enum DatabaseError: Error {
    case unknown
}

protocol NutritionalControllerProtocol {
    func getNutritionalByIds(_ idList: [UUID]) async throws -> [InternalNutritionalModel]
    func saveNutritionalModel(_ model: InternalNutritionalModel) async throws -> InternalNutritionalModel
    func deleteNutritionalModel(_ model: InternalNutritionalModel) async throws
}

struct NutritionalController: NutritionalControllerProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: NutritionalRepositoryProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: NutritionalRepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
    }

    func getNutritionalByIds(_ idList: [UUID]) async throws -> [InternalNutritionalModel] {
        var nutritionalList = [InternalNutritionalModel]()

        for id in idList {
            if let result = try await repository.getNutritionalById(id) {
                nutritionalList.append(result)
            }
        }

        return nutritionalList
    }

    func saveNutritionalModel(_ model: InternalNutritionalModel) async throws -> InternalNutritionalModel {
        let result = try await repository.getNutritionalByAllFields(model)

        if let result {
            return result
        }

        try await repository.saveNutritionalModel(model)

        let savedResult = try await repository.getNutritionalByAllFields(model)

        if let savedResult {
            return savedResult
        }

        throw DatabaseError.unknown
    }

    func deleteNutritionalModel(_ model: InternalNutritionalModel) async throws {
        try await repository.deleteNutritionalModel(model)
    }
}

