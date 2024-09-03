import FluentPostgresDriver
import Fluent
import Vapor

enum OrderDbField: String {
    case schema = "order"
    
    case id
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case userId = "user_id"
    case voucherCode = "voucher_code"
    case paymentId = "payment_id"
    case deliveryAddress = "delivery_address"
    case deliveryStatus = "delivery_status"
    case orderStatus = "order_status"
    
    var fieldKey: FieldKey {
        return FieldKey(stringLiteral: self.rawValue)
    }
}

final class Order: Model {
    static let schema = OrderDbField.schema.rawValue

    @ID(key: .id)
    var id: UUID?
    
    @Timestamp(key: OrderDbField.createdAt.fieldKey, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: OrderDbField.updatedAt.fieldKey, on: .none)
    var updatedAt: Date?

    @Field(key: OrderDbField.userId.fieldKey)
    var userId: UUID
    
    @OptionalField(key: OrderDbField.voucherCode.fieldKey)
    var voucherCode: String?
    
    @Field(key: OrderDbField.paymentId.fieldKey)
    var paymentId: UUID
    
    @Field(key: OrderDbField.deliveryAddress.fieldKey)
    var deliveryAddress: String
    
    @Field(key: OrderDbField.deliveryStatus.fieldKey)
    var deliveryStatus: DeliveryStatus
    
    @Field(key: OrderDbField.orderStatus.fieldKey)
    var orderStatus: OrderStatus
    
    internal init() { }
    
    init(id: UUID? = nil,
         createdAt: Date? = nil,
         updatedAt: Date? = nil,
         userId: UUID,
         voucherCode: String? = nil,
         paymentId: UUID,
         deliveryAddress: String,
         deliveryStatus: DeliveryStatus,
         orderStatus: OrderStatus) {
        self.id = id
        self.userId = userId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.voucherCode = voucherCode
        self.paymentId = paymentId
        self.deliveryAddress = deliveryAddress
        self.deliveryStatus = deliveryStatus
        self.orderStatus = orderStatus
    }
}
