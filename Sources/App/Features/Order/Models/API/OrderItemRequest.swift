import Vapor

struct APIOrderItem: Codable, Content {
    var orderId: UUID
    var product: [APIProduct]
    var quantity: Double
    var unitValue: Double
    var orderStatus: OrderStatus
}
