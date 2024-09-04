import Foundation
import Fluent

enum OrderItemDbField: String {
    case schema = "order_item"
    
    case id
    case orderId = "oder_id"
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

    @Parent(key: OrderItemDbField.orderId.fieldKey)
    var order: Order

    @Field(key: OrderItemDbField.productId.fieldKey)
    var product: Product

    @Field(key: OrderItemDbField.quantity.fieldKey)
    var quantity: Double
    
    @Field(key: OrderItemDbField.unitValue.fieldKey)
    var unitValue: Double
    
    @Field(key: OrderItemDbField.orderStatus.fieldKey)
    var orderStatus: OrderStatus

    internal init() { }

    init(id: UUID? = nil, 
         order: Order,
         product: Product,
         quantity: Double,
         unitValue: Double,
         orderStatus: OrderStatus) {
        self.id = id
        self.order = order
        self.product = product
        self.quantity = quantity
        self.unitValue = unitValue
        self.orderStatus = orderStatus
    }
}
