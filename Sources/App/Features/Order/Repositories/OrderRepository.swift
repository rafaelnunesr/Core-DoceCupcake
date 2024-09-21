import FluentPostgresDriver
import Vapor

protocol OrderRepositoryProtocol: Sendable {
    func fetchAllOrdersByStatus(_ status: OrderStatus) async throws -> [Order]
    func fetchAllOrdersByUserId(_ userId: UUID) async throws -> [Order]
    func fetchOrderByNumber(_ orderNumber: String) async throws -> Order?
    func create(_ order: Order) async throws
    func update(_ order: Order) async throws
    func delete(_ order: Order) async throws
}

final class OrderRepository: OrderRepositoryProtocol {
    let database: Database

    init(database: Database) {
        self.database = database
    }
    
    func fetchAllOrdersByStatus(_ status: OrderStatus) async throws -> [Order] {
        try await Order.query(on: database)
            .filter(\.$orderStatus == status.rawValue)
            .all()
    }
    
    func fetchAllOrdersByUserId(_ userId: UUID) async throws -> [Order] {
        try await Order.query(on: database)
            .filter(\.$userId == userId)
            .all()
    }
    
    func fetchOrderByNumber(_ number: String) async throws -> Order? {
        try await Order.query(on: database)
            .filter(\.$number == number)
            .first()
    }

    func create(_ order: Order) async throws {
        try await order.create(on: database)
    }
    
    func update(_ order: Order) async throws {
        try await order.update(on: database)
    }

    func delete(_ order: Order) async throws {
        try await order.delete(on: database)
    }
}
