import Vapor

struct APIOrderItem: Codable, Content {
    var orderId: UUID
    var product: APIProduct
    var quantity: Double
    var unitValue: Double
    var orderStatus: OrderStatus
}

extension APIOrderItem {
    init(from model: OrderItem, product: APIProduct) {
        orderId = model.id ?? UUID()
        self.product = product
        quantity = model.quantity
        unitValue = model.unitValue
        orderStatus = OrderStatus(rawValue: model.orderStatus) ?? .cancelled
    }
}
