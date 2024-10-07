import FluentPostgresDriver
import Foundation
import Vapor

protocol NutritionalControllerProtocol: Sendable {
    func fetchNutritionalByIds(_ idList: [UUID]) async throws -> [NutritionalInformation]
    func save(_ model: NutritionalInformation) async throws -> NutritionalInformation
    func delete(_ model: NutritionalInformation) async throws
}

struct NutritionalController: NutritionalControllerProtocol {
    private let repository: NutritionalRepositoryProtocol

    init(repository: NutritionalRepositoryProtocol) {
        self.repository = repository
    }

    func fetchNutritionalByIds(_ idList: [UUID]) async throws -> [NutritionalInformation] {
        var nutritionalList = [NutritionalInformation]()

        for id in idList {
            if let result: NutritionalInformation = try await repository.fetchModelById(id) {
                nutritionalList.append(result)
            }
        }

        return nutritionalList
    }

    func save(_ model: NutritionalInformation) async throws -> NutritionalInformation {
        let result = try await repository.fetchNutritionalByAllFields(model)

        if let result {
            return result
        }

        try await repository.create(model)

        return model
    }

    func delete(_ model: NutritionalInformation) async throws {
        try await repository.delete(model)
    }
}
