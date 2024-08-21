import FluentPostgresDriver
import Vapor

protocol ProductTagsRepositoryProtocol {
    func getTag(with code: String) async throws -> InternalProductTagModel?
    func getAllTags() async throws -> [InternalProductTagModel]
    func createNewTag(_ tag: InternalProductTagModel) async throws
    func deleteTag(_ tag: InternalProductTagModel) async throws
}

final class ProductTagsRepository: ProductTagsRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }

    func getAllTags() async throws -> [InternalProductTagModel] {
        try await InternalProductTagModel.query(on: database)
            .all()
    }

    func getTag(with code: String) async throws -> InternalProductTagModel? {
        try await InternalProductTagModel.query(on: database)
            .filter(\.$code == code)
            .first()
    }

    func createNewTag(_ tag: InternalProductTagModel) async throws {
        try await tag.create(on: database)
    }

    func deleteTag(_ tag: InternalProductTagModel) async throws {
        try await tag.delete(on: database)
    }
}
