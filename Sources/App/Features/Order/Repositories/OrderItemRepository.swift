import FluentPostgresDriver
import Vapor

protocol OrderItemRepositoryProtocol: Sendable {
    func fetchOrdersByOrderId(_ orderId: UUID) async throws -> [OrderItem]
    func create(_ item: OrderItem) async throws
    func update(_ item: OrderItem) async throws
    func delete(_ item: OrderItem) async throws
}

final class OrderItemRepository: OrderItemRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }
    
    func fetchOrdersByOrderId(_ orderId: UUID) async throws -> [OrderItem] {
        try await OrderItem.query(on: database)
            .filter(\.$orderId == orderId)
            .all()
    }

    func create(_ item: OrderItem) async throws {
        try await item.create(on: database)
    }
    
    func update(_ item: OrderItem) async throws {
        try await item.update(on: database)
    }

    func delete(_ item: OrderItem) async throws {
        try await item.delete(on: database)
    }
}
