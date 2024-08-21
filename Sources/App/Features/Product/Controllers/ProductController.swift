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
        productRoutes.get(":id", use: getProduct)
        productRoutes.post(use: createNewProduct)
        productRoutes.put(use: updateProduct)
        productRoutes.delete(use: deleteProduct)
    }

    private func getProductList(req: Request) async throws -> APIProductResponse {
        return APIProductResponse(id: "1", name: "Chocolate", description: "Super", originalPrice: 1.99, currentPrice: 1.99, currentDiscount: 0, stockCount: 10, launchDate: "10/08/2023", tags: [], allergicTags: [], nutritionalInformations: [])
    }

    private func getProduct(req: Request) async throws -> String {
        .empty
    }

    private func createNewProduct(req: Request) async throws -> String {
        // check user privilegies
        .empty
    }

    private func updateProduct(req: Request) async throws -> String {
        // check user privilegies
        .empty
    }

    private func deleteProduct(req: Request) async throws -> String {
        // check user privilegies
        .empty
    }
}
