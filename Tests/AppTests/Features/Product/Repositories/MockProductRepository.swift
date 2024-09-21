import Foundation

@testable import App

final class MockProductRepository: ProductRepositoryProtocol {
    var result: Product?

    func fetchProduct(with code: String) async throws -> Product? {
        result
    }
    
    func fetchProduct(with id: UUID) async throws -> Product? {
        result
    }

    func fetchProducts() async throws -> [Product] {
        if let result {
            return [result]
        }
        
        return []
    }

    func create(_ product: Product) async throws {
        result = product
    }

    func update(_ product: Product) async throws {
        result = product
    }

    func delete(_ product: Product) async throws {
        result = nil
    }
}
