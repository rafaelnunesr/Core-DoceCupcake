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
    case voucherCode = "voucher_code"
    case paymentId = "payment_id"
    case total = "total"
    case deliveryFee = "delivery_fee"
    case addressCode = "address_code"
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

    @Field(key: OrderDbField.userId.fieldKey)
    var userId: UUID
    
    @OptionalField(key: OrderDbField.voucherCode.fieldKey)
    var voucherCode: String?
    
    @Field(key: OrderDbField.paymentId.fieldKey)
    var paymentId: UUID?
    
    @Field(key: OrderDbField.total.fieldKey)
    var total: Double
    
    @Field(key: OrderDbField.deliveryFee.fieldKey)
    var deliveryFee: Double
    
    @Field(key: OrderDbField.addressCode.fieldKey)
    var addressCode: String
    
    @Field(key: OrderDbField.deliveryStatus.fieldKey)
    var deliveryStatus: TransportationStatus
    
    @Field(key: OrderDbField.orderStatus.fieldKey)
    var orderStatus: OrderStatus
    
    internal init() { }
    
    init(id: UUID? = nil,
         code: String,
         createdAt: Date? = nil,
         updatedAt: Date? = nil,
         userId: UUID,
         voucherCode: String? = nil,
         paymentId: UUID,
         total: Double,
         deliveryFee: Double,
         addressCode: String,
         deliveryStatus: TransportationStatus,
         orderStatus: OrderStatus) {
        self.id = id
        self.code = code
        self.userId = userId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.voucherCode = voucherCode
        self.paymentId = paymentId
        self.total = total
        self.deliveryFee = deliveryFee
        self.addressCode = addressCode
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
        self.init(code: model.orderNumber ?? .empty,
                  userId: userId,
                  voucherCode: model.voucherCode,
                  paymentId: paymentId,
                  total: total,
                  deliveryFee: model.deliveryFee,
                  addressCode: model.addressCode,
                  deliveryStatus: .confirmed,
                  orderStatus: .confirmed)
    }
}
