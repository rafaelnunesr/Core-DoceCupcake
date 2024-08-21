import FluentPostgresDriver
import Foundation
import Vapor

struct ProductController: RouteCollection {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: ProductRepositoryProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: ProductRepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
    }

    func boot(routes: RoutesBuilder) throws {
        let productRoutes = routes.grouped("productList")
        productRoutes.get(use: getProductList)
    }

    func getProductList(req: Request) async throws -> APIProductResponse {
        return APIProductResponse(id: "1", name: "Chocolate", description: "Super", originalPrice: 1.99, currentPrice: 1.99, currentDiscount: 0, stockCount: 10, launchDate: "10/08/2023", tags: [], allergicTags: [], nutritionalInformations: [])
    }
}
