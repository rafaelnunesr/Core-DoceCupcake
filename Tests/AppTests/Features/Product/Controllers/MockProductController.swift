import Vapor

@testable import App

struct MockProductController: ProductControllerProtocol {
    var product: Product?
    
    func boot(routes: RoutesBuilder) throws {}
    
    func fetchProduct(with code: String) async throws -> Product? {
        product
    }
    
    func fetchProduct(with productId: UUID) async throws -> Product? {
        product
    }
    
    func checkProductAvailability(with code: String, and quantity: Double) async throws -> Bool {
        true
    }
    
    func updateProductAvailability(with code: String, and quantity: Double) async throws {}
}
