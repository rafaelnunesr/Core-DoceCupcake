import Foundation
import Fluent

enum OrderItemDbField: String {
    case schema = "order_item"
    
    case id
    case orderId = "order_id"
    case productId = "product_id"
    case quantity
    case unitValue = "unit_value"
    case orderStatus = "order_status"
    
    var fieldKey: FieldKey {
        return FieldKey(stringLiteral: self.rawValue)
    }
}

final class OrderItem: Model {
    static let schema = OrderItemDbField.schema.rawValue

    @ID(key: .id)
    var id: UUID?

    @Field(key: OrderItemDbField.orderId.fieldKey)
    var orderId: UUID

    @Field(key: OrderItemDbField.productId.fieldKey)
    var productId: UUID

    @Field(key: OrderItemDbField.quantity.fieldKey)
    var quantity: Double
    
    @Field(key: OrderItemDbField.unitValue.fieldKey)
    var unitValue: Double
    
    @Field(key: OrderItemDbField.orderStatus.fieldKey)
    var orderStatus: Int

    internal init() { }

    init(id: UUID? = nil, 
         orderId: UUID,
         productId: UUID,
         quantity: Double,
         unitValue: Double,
         orderStatus: Int) {
        self.id = id
        self.orderId = orderId
        self.productId = productId
        self.quantity = quantity
        self.unitValue = unitValue
        self.orderStatus = orderStatus
    }
}
