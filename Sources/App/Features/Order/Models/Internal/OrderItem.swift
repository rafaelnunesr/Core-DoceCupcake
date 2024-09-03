import Foundation
import Fluent

enum OrderItemDbField: String {
    case schema = "order_item"
    
    case id
    case orderId = "order_id"
    case paymentId = "product_id"
    case quantity
    case deliveryStatus = "unit_value"
    case orderStatus = "order_status"
    
    var fieldKey: FieldKey {
        return FieldKey(stringLiteral: self.rawValue)
    }
}

final class OrderItem: Model, @unchecked Sendable {
    static let schema = "order_item"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "order_id")
    var orderId: UUID

    @Field(key: "product_id")
    var productId: UUID

    @Field(key: "quantity")
    var quantity: Double
    
    @Field(key: "unit_value")
    var unitValue: Double
    
    @Field(key: "order_status")
    var orderStatus: OrderStatus

    internal init() { }

    init(id: UUID? = nil, 
         orderId: UUID,
         productId: UUID,
         quantity: Double,
         unitValue: Double,
         orderStatus: OrderStatus) {
        self.id = id
        self.orderId = orderId
        self.productId = productId
        self.quantity = quantity
        self.unitValue = unitValue
        self.orderStatus = orderStatus
    }
}
