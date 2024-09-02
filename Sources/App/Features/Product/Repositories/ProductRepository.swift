import FluentPostgresDriver
import Vapor

protocol ProductRepositoryProtocol {
    func getProduct(with id: String) async throws -> Product?
    func getProductList() async throws -> [Product]
    func createProduct(_ product: Product) async throws
    func updateProduct(_ product: Product) async throws
    func deleteProduct(_ product: Product) async throws
}

final class ProductRepository: ProductRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }

    func getProduct(with id: String) async throws -> Product? {
        try await Product.query(on: database)
            .filter(\.$productId == id)
            .first()
    }

    func getProductList() async throws -> [Product] {
        try await Product.query(on: database)
            .all()
    }

    func createProduct(_ product: Product) async throws {
        try await product.create(on: database)
    }

    func updateProduct(_ product: Product) async throws {
        try await product.update(on: database)
    }

    func deleteProduct(_ product: Product) async throws {
        try await product.delete(on: database)
    }
}
