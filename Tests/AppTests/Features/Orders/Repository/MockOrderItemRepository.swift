import Foundation

@testable import App

final class MockOrderItemRepository: OrderItemRepositoryProtocol {
    var result: OrderItem?
    
    func fetchOrdersByOrderId(_ orderId: UUID) async throws -> [OrderItem] {
        if let result {
            return [result]
        }
        
        return []
    }
    
    func create(_ item: OrderItem) async throws {
        result = item
    }
    
    func update(_ item: OrderItem) async throws {
        result = item
    }

    func delete(_ item: OrderItem) async throws {
        result = nil
    }
}
