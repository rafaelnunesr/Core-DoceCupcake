import FluentPostgresDriver
import Vapor

protocol OrderRepositoryProtocol: Sendable {
    func fetchAllOrdersByStatus(_ status: OrderStatus) async throws -> [Order]
    func fetchAllOrdersByUserId(_ userId: UUID) async throws -> [Order]
    func fetchOrderById(_ orderId: UUID) async throws -> Order?
    func create(_ order: Order) async throws
    func update(_ order: Order) async throws
    func delete(_ order: Order) async throws
}

final class OrderRepository: OrderRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }
    
    func fetchAllOrdersByStatus(_ status: OrderStatus) async throws -> [Order] {
        try await Order.query(on: database)
            .filter(\.$orderStatus == status)
            .all()
    }
    
    func fetchAllOrdersByUserId(_ userId: UUID) async throws -> [Order] {
        try await Order.query(on: database)
            .filter(\.$userId == userId)
            .all()
    }
    
    func fetchOrderById(_ orderId: UUID) async throws -> Order? {
        try await Order.query(on: database)
            .filter(\.$id == orderId)
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
