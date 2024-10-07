import Foundation

@testable import App

final class MockOrderRepository: OrderRepositoryProtocol {
    var result: Order?
    
    func fetchAllOrdersByStatus(_ status: OrderStatus) async throws -> [Order] {
        if let result {
            return [result]
        }
        
        return []
    }
    
    func fetchAllOrdersByUserId(_ userId: UUID) async throws -> [Order] {
        if let result {
            return [result]
        }
        
        return []
    }
    
    func fetchOrderByNumber(_ number: String) async throws -> Order? {
        return result
    }
    
    func create(_ order: Order) async throws {
        result = order
    }
    
    func update(_ order: Order) async throws {
        result = order
    }

    func delete(_ order: Order) async throws {
        result = nil
    }
}
