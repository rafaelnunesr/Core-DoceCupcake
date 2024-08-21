import FluentPostgresDriver
import Foundation
import Vapor

struct ProductTagsController: RouteCollection {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: ProductTagsRepositoryProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: ProductTagsRepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
    }

    func boot(routes: RoutesBuilder) throws {
        let productRoutes = routes.grouped("productTags")
        productRoutes.get(use: getProductTagsList)
    }

    func getProductTagsList(req: Request) async throws -> APIProductTagListResponse {
        let result = try await repository.getTags()
        let tags = result.map { APIProductTagResponse(from: $0) }
        return APIProductTagListResponse(count: tags.count, tags: tags)
    }
}
