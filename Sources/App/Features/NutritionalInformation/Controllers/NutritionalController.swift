import FluentPostgresDriver
import Foundation
import Vapor

protocol NutritionalControllerProtocol: Sendable {
    func getNutritionalByIds(_ idList: [UUID]) async throws -> [NutritionalInformation]
    func saveNutritionalModel(_ model: NutritionalInformation) async throws -> NutritionalInformation
    func deleteNutritionalModel(_ model: NutritionalInformation) async throws
}

struct NutritionalController: NutritionalControllerProtocol {
    private let repository: NutritionalRepositoryProtocol

    init(repository: NutritionalRepositoryProtocol) {
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

        return model
    }

    func deleteNutritionalModel(_ model: NutritionalInformation) async throws {
        try await repository.delete(model)
    }
}
