import Vapor

@testable import App

struct MockProductController: ProductControllerProtocol {
    func boot(routes: RoutesBuilder) throws {}
    
    func fetchProduct(with code: String) async throws -> Product? {
        nil
    }
    
    func fetchProduct(with productId: UUID) async throws -> Product? {
        nil
    }
    
    func checkProductAvailability(with code: String, and quantity: Double) async throws -> Bool {
        false
    }
    
    func updateProductAvailability(with code: String, and quantity: Double) async throws {}
}
