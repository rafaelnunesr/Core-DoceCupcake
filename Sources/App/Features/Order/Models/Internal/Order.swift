import FluentPostgresDriver
import Fluent
import Vapor

enum OrderDbField: String {
    case schema = "order_"
    
    case id
    case number
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case userId = "user_id"
    case voucherCode = "voucher_code"
    case paymentId = "payment_id"
    case total
    case subtotal
    case discount
    case deliveryFee = "delivery_fee"
    case addressId = "address_id"
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
    var number: String

    @Field(key: OrderDbField.userId.fieldKey)
    var userId: UUID
    
    @OptionalField(key: OrderDbField.voucherCode.fieldKey)
    var voucherCode: String?
    
    @Field(key: OrderDbField.paymentId.fieldKey)
    var paymentId: UUID?
    
    @Field(key: OrderDbField.subtotal.fieldKey)
    var subtotal: Double
    
    @Field(key: OrderDbField.deliveryFee.fieldKey)
    var deliveryFee: Double
    
    @Field(key: OrderDbField.discount.fieldKey)
    var discount: Double
    
    @Field(key: OrderDbField.total.fieldKey)
    var total: Double
    
    @Field(key: OrderDbField.addressId.fieldKey)
    var addressId: UUID
    
    @Field(key: OrderDbField.orderStatus.fieldKey)
    var orderStatus: Int
    
    internal init() { }
    
    init(id: UUID? = nil,
         number: String,
         createdAt: Date? = nil,
         updatedAt: Date? = nil,
         userId: UUID,
         voucherCode: String? = nil,
         paymentId: UUID,
         total: Double,
         discount: Double,
         subtotal: Double,
         deliveryFee: Double,
         addressId: UUID,
         orderStatus: Int) {
        self.id = id
        self.number = number
        self.userId = userId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.voucherCode = voucherCode
        self.paymentId = paymentId
        self.total = total
        self.discount = discount
        self.subtotal = subtotal
        self.deliveryFee = deliveryFee
        self.addressId = addressId
        self.orderStatus = orderStatus
    }
}

extension Order {
    convenience init(from model: APIOrderRequest,
                     number: String,
                     userId: UUID,
                     paymentId: UUID,
                     total: Double,
                     discount: Double,
                     deliveryFee: Double,
                     subtotal: Double,
                     addressId: UUID) {
        self.init(number: number,
                  userId: userId,
                  voucherCode: model.voucherCode,
                  paymentId: paymentId,
                  total: total,
                  discount: discount,
                  subtotal: subtotal,
                  deliveryFee: deliveryFee,
                  addressId: addressId,
                  orderStatus: OrderStatus.orderPlaced.rawValue)
    }
}
