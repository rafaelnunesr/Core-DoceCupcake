@testable import App

final class MockProductRepository: ProductRepositoryProtocol {
    var result: Product?

    func getProduct(with code: String) async throws -> Product? {
        result
    }

    func getProductList() async throws -> [Product] {
        if let result {
            return [result]
        }
        
        return []
    }

    func createProduct(_ product: Product) async throws {
        result = product
    }

    func updateProduct(_ product: Product) async throws {
        result = product
    }

    func deleteProduct(_ product: Product) async throws {
        result = nil
    }
}
