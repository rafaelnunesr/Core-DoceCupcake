import FluentPostgresDriver
import Fluent
import Vapor

final class Order: Model {
    static let schema = "order"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "user_id")
    var userId: UUID
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .none)
    var updatedAt: Date?
    
    @Field(key: "vouchers_ids")
    var vouchersIds: [UUID]
    
    @Field(key: "payment_id")
    var paymentId: UUID
    
    @Field(key: "address")
    var address: String
    
    @Field(key: "delivery_status")
    var deliveryStatus: DeliveryStatus
    
    @Field(key: "order_status")
    var orderStatus: OrderStatus
    
    internal init() { }
    
    init(id: UUID? = nil,
         userId: UUID,
         createdAt: Date? = nil,
         updatedAt: Date? = nil,
         vouchersIds: [UUID],
         paymentId: UUID,
         address: String,
         deliveryStatus: DeliveryStatus,
         orderStatus: OrderStatus) {
        self.id = id
        self.userId = userId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.vouchersIds = vouchersIds
        self.paymentId = paymentId
        self.address = address
        self.deliveryStatus = deliveryStatus
        self.orderStatus = orderStatus
    }
}
