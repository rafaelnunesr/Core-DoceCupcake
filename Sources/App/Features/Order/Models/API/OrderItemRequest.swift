import Vapor

struct APIOrderItem: Codable, Content {
    var orderId: UUID
    var product: APIProduct
    var quantity: Double
    var unitValue: Double
    var orderStatus: OrderStatus
    var canReviewProduct: Bool
    
    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case product
        case quantity
        case unitValue = "unit_value"
        case orderStatus = "order_status"
        case canReviewProduct = "can_review_product"
    }
}

extension APIOrderItem {
    init(from model: OrderItem, product: APIProduct) {
        orderId = model.id ?? UUID()
        self.product = product
        quantity = model.quantity
        unitValue = model.unitValue
        orderStatus = OrderStatus(rawValue: model.orderStatus) ?? .cancelled
        canReviewProduct = model.reviewId == nil && orderStatus == .delivered
    }
}
