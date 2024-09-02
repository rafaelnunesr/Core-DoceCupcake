import Vapor

struct APIOrder: Codable, Content {
    var createdAt: Date?
    var updatedAt: Date?
    var vouchersIds: [UUID]
    var address: String
    var deliveryStatus: DeliveryStatus
    var orderStatus: OrderStatus
    var items: [APIOrderItem]
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case vouchersIds = "vouchers_ids"
        case address
        case deliveryStatus = "delivery_status"
        case orderStatus = "order_status"
        case items
    }
}
