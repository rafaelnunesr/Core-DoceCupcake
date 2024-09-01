import Fluent
import Vapor

final class InternalOrderModel: Model {
    static let schema = "orders"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "user_id")
    var userId: UUID
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .none)
    var updatedAt: Date?
    
    @Field(key: "products")
    var products: [String]
    
    @Field(key: "vouchers_ids")
    var vouchersIds: [UUID]
    
    @Field(key: "payment_id")
    var paymentId: UUID
    
    @Field(key: "address")
    var address: String
    
    @Field(key: "transportation_status")
    var transportationStatus: [String]
    
    internal init() { }
    
    init(id: UUID? = nil,
         userId: UUID,
         createdAt: Date?,
         updatedAt: Date?,
         products: [String],
         vouchersIds: [UUID],
         paymentId: UUID,
         address: String,
         transportationStatus: [String]) {
        self.id = id
        self.userId = userId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.products = products
        self.vouchersIds = vouchersIds
        self.paymentId = paymentId
        self.address = address
        self.transportationStatus = transportationStatus
    }
}

extension InternalOrderModel {
}
