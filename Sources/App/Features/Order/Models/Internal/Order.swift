import FluentPostgresDriver
import Fluent
import Vapor

enum OrderDbField: String {
    case schema = "order"
    
    case id
    case code
    case orderNumber = "order_number"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case userId = "user_id"
    case voucherId = "voucher_id"
    case paymentId = "payment_id"
    case total = "total"
    case deliveryFee = "delivery_fee"
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
    
    @Field(key: OrderDbField.orderNumber.fieldKey)
    var orderNumber: Int
    
    @Timestamp(key: OrderDbField.createdAt.fieldKey, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: OrderDbField.updatedAt.fieldKey, on: .none)
    var updatedAt: Date?

    @Field(key: OrderDbField.userId.fieldKey)
    var userId: UUID
    
    @OptionalField(key: OrderDbField.voucherId.fieldKey)
    var voucherId: UUID?
    
    @Field(key: OrderDbField.paymentId.fieldKey)
    var paymentId: UUID?
    
    @Field(key: OrderDbField.total.fieldKey)
    var total: Double
    
    @Field(key: OrderDbField.deliveryFee.fieldKey)
    var deliveryFee: Double
    
    @Field(key: OrderDbField.addressId.fieldKey)
    var addressId: UUID
    
    @Field(key: OrderDbField.deliveryStatus.fieldKey)
    var deliveryStatus: TransportationStatus
    
    @Field(key: OrderDbField.orderStatus.fieldKey)
    var orderStatus: OrderStatus
    
    internal init() { }
    
    init(id: UUID? = nil,
         code: String,
         orderNumber: Int,
         createdAt: Date? = nil,
         updatedAt: Date? = nil,
         userId: UUID,
         voucherId: UUID? = nil,
         paymentId: UUID,
         total: Double,
         deliveryFee: Double,
         addressId: UUID,
         deliveryStatus: TransportationStatus,
         orderStatus: OrderStatus) {
        self.id = id
        self.code = code
        self.orderNumber = orderNumber
        self.userId = userId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.voucherId = voucherId
        self.paymentId = paymentId
        self.total = total
        self.deliveryFee = deliveryFee
        self.addressId = addressId
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

extension Order {
    convenience init(from model: APIOrderRequest, userId: UUID, paymentId: UUID, total: Double) {
        self.init(code: "", // review this logic
                  orderNumber: 1, // review this
                  userId: userId,
                  voucherId: model.voucherId,
                  paymentId: paymentId,
                  total: total,
                  deliveryFee: model.deliveryFee,
                  addressId: model.addressId,
                  deliveryStatus: .confirmed,
                  orderStatus: .confirmed)
    }
}
