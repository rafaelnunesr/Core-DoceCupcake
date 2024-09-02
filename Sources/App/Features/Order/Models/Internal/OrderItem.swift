import Foundation
import Fluent

final class OrderItem: Model {
    static let schema = "order_item"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "order_id")
    var orderId: UUID

    @Field(key: "product_id")
    var productId: UUID

    @Field(key: "quantity")
    var quantity: Int
    
    @Field(key: "unit_value")
    var unitValue: Double
    
    @Field(key: "order_status")
    var orderStatus: OrderStatus

    internal init() { }

    init(id: UUID? = nil, 
         orderId: UUID,
         productId: UUID,
         quantity: Int,
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
