import FluentPostgresDriver
import Vapor

protocol ProductRepositoryProtocol {
    func getProduct(with id: String) async throws -> InternalProductModel?
    func getProductList() async throws -> [InternalProductModel]
    func createProduct(_ product: InternalProductModel) async throws
    func updateProduct(_ product: InternalProductModel) async throws
    func deleteProduct(_ product: InternalProductModel) async throws
}

final class ProductRepository: ProductRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }

    func getProduct(with id: String) async throws -> InternalProductModel? {
        try await InternalProductModel.query(on: database)
            .filter(\.$productId == id)
            .first()
    }

    func getProductList() async throws -> [InternalProductModel] {
        try await InternalProductModel.query(on: database)
            .all()
    }

    func createProduct(_ product: InternalProductModel) async throws {
        try await product.create(on: database)
    }

    func updateProduct(_ product: InternalProductModel) async throws {
        try await product.update(on: database)
    }

    func deleteProduct(_ product: InternalProductModel) async throws {
        try await product.delete(on: database)
    }
}
