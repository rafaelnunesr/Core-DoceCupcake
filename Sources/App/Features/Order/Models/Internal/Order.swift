import FluentPostgresDriver
import Fluent
import Vapor

enum OrderDbField: String {
    case schema = "order"
    
    case id
    case code
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case userId = "user_id"
    case voucherId = "voucher_id"
    case paymentId = "payment_id"
    case addressId = "address_id"
    case deliveryStatus = "delivery_status"
    case orderStatus = "order_status"
    
    var fieldKey: FieldKey {
        return FieldKey(stringLiteral: self.rawValue)
    }
}

final class Order: DatabaseModelProtocol {
    static let schema = OrderDbField.schema.rawValue

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: OrderDbField.code.fieldKey)
    var code: String
    
    @Timestamp(key: OrderDbField.createdAt.fieldKey, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: OrderDbField.updatedAt.fieldKey, on: .none)
    var updatedAt: Date?

    @Parent(key: OrderDbField.userId.fieldKey)
    var user: User
    
    @OptionalParent(key: OrderDbField.voucherId.fieldKey)
    var voucher: Voucher?
    
    @Parent(key: OrderDbField.paymentId.fieldKey)
    var payment: CreditCard
    
    @Parent(key: OrderDbField.addressId.fieldKey)
    var deliveryAddress: Address
    
    @Field(key: OrderDbField.deliveryStatus.fieldKey)
    var deliveryStatus: DeliveryStatus
    
    @Field(key: OrderDbField.orderStatus.fieldKey)
    var orderStatus: OrderStatus
    
    internal init() { }
    
    init(id: UUID? = nil,
         code: String,
         createdAt: Date? = nil,
         updatedAt: Date? = nil,
         user: User,
         voucher: Voucher? = nil,
         payment: CreditCard,
         deliveryAddress: Address,
         deliveryStatus: DeliveryStatus,
         orderStatus: OrderStatus) {
        self.id = id
        self.code = code
        self.user = user
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.voucher = voucher
        self.payment = payment
        self.deliveryAddress = deliveryAddress
        self.deliveryStatus = deliveryStatus
        self.orderStatus = orderStatus
    }
}

extension Order {
    static var codeKey: KeyPath<Order, Field<String>> {
        \Order.$code
    }

    static var idKey: KeyPath<Order, IDProperty<Order, UUID>> {
        \Order.$id
    }
}
