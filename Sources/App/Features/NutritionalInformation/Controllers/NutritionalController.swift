import FluentPostgresDriver
import Foundation
import Vapor

enum DatabaseError: Error {
    case unknown
}

protocol NutritionalControllerProtocol {
    func getNutritionalByIds(_ idList: [UUID]) async throws -> [NutritionalInformation]
    func saveNutritionalModel(_ model: NutritionalInformation) async throws -> NutritionalInformation
    func deleteNutritionalModel(_ model: NutritionalInformation) async throws
}

struct NutritionalController: NutritionalControllerProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: NutritionalRepositoryProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: NutritionalRepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
    }

    func getNutritionalByIds(_ idList: [UUID]) async throws -> [NutritionalInformation] {
        var nutritionalList = [NutritionalInformation]()

        for id in idList {
            if let result: NutritionalInformation = try await repository.fetchModelById(id) {
                nutritionalList.append(result)
            }
        }

        return nutritionalList
    }

    func saveNutritionalModel(_ model: NutritionalInformation) async throws -> NutritionalInformation {
        let result = try await repository.getNutritionalByAllFields(model)

        if let result {
            return result
        }

        try await repository.create(model)

        let savedResult = try await repository.getNutritionalByAllFields(model)

        if let savedResult {
            return savedResult
        }

        throw DatabaseError.unknown
    }

    func deleteNutritionalModel(_ model: NutritionalInformation) async throws {
        try await repository.delete(model)
    }
}
