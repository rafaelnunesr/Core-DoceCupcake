import FluentPostgresDriver
import Vapor

protocol ProductRepositoryProtocol: Sendable {
    func fetchProduct(with code: String) async throws -> Product?
    func fetchProduct(with id: UUID) async throws -> Product?
    func fetchProducts(with value: String) async throws -> [Product]
    func fetchProducts() async throws -> [Product]
    func create(_ product: Product) async throws
    func update(_ product: Product) async throws
    func delete(_ product: Product) async throws
}

final class ProductRepository: ProductRepositoryProtocol {
    private let database: Database

    init(database: Database) {
        self.database = database
    }

    func fetchProduct(with code: String) async throws -> Product? {
        try await Product.query(on: database)
            .filter(\.$code == code)
            .first()
    }
    
    func fetchProduct(with id: UUID) async throws -> Product? {
        try await Product.query(on: database)
            .filter(\.$id == id)
            .first()
    }

    func fetchProducts() async throws -> [Product] {
        try await Product.query(on: database)
            .all()
    }
    
    func fetchProducts(with value: String) async throws -> [Product] {
        try await Product.query(on: database)
            .group(.or) { or in
                or.filter(\.$code ~~ value)
                or.filter(\.$name ~~ value)
            }
            .all()
    }

    func create(_ product: Product) async throws {
        try await product.create(on: database)
    }

    func update(_ product: Product) async throws {
        try await product.update(on: database)
    }

    func delete(_ product: Product) async throws {
        try await product.delete(on: database)
    }
}
