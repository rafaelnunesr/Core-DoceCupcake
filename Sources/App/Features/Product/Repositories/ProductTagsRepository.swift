import FluentPostgresDriver
import Vapor

protocol ProductTagsRepositoryProtocol {
    func getTags() async throws -> [InternalProductTagModel]
    func createNewTag() async throws
}

final class ProductTagsRepository: ProductTagsRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }

    func getTags() async throws -> [InternalProductTagModel] {
        try await InternalProductTagModel.query(on: database)
            .all()
    }

    func createNewTag() async throws {}

}
