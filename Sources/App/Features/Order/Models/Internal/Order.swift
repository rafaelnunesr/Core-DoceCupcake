import FluentPostgresDriver
import Fluent
import Vapor

enum OrderDbField: String {
    case schema = "order"
    
    case id
    case number
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case userId = "user_id"
    case voucherCode = "voucher_code"
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

final class Order: Model {
    static let schema = OrderDbField.schema.rawValue

    @ID(key: .id)
    var id: UUID?
    
    @Timestamp(key: OrderDbField.createdAt.fieldKey, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: OrderDbField.updatedAt.fieldKey, on: .none)
    var updatedAt: Date?
    
    @Field(key: OrderDbField.number.fieldKey)
    var number: Int

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
    
    @Field(key: OrderDbField.addressId.fieldKey)
    var addressId: UUID
    
    @Field(key: OrderDbField.deliveryStatus.fieldKey)
    var deliveryStatus: TransportationStatus
    
    @Field(key: OrderDbField.orderStatus.fieldKey)
    var orderStatus: OrderStatus
    
    internal init() { }
    
    init(id: UUID? = nil,
         number: Int,
         createdAt: Date? = nil,
         updatedAt: Date? = nil,
         userId: UUID,
         voucherCode: String? = nil,
         paymentId: UUID,
         total: Double,
         deliveryFee: Double,
         addressId: UUID,
         deliveryStatus: TransportationStatus,
         orderStatus: OrderStatus) {
        self.id = id
        self.number = number
        self.userId = userId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.voucherCode = voucherCode
        self.paymentId = paymentId
        self.total = total
        self.deliveryFee = deliveryFee
        self.addressId = addressId
        self.deliveryStatus = deliveryStatus
        self.orderStatus = orderStatus
    }
}

extension Order {
    convenience init(from model: APIOrderRequest, userId: UUID, paymentId: UUID, total: Double) {
        self.init(number: model.orderNumber ?? .zero,
                  userId: userId,
                  voucherCode: model.voucherCode,
                  paymentId: paymentId,
                  total: total,
                  deliveryFee: model.deliveryFee,
                  addressId: model.addressId,
                  deliveryStatus: .confirmed,
                  orderStatus: .confirmed)
    }
}
