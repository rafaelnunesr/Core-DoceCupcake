import Vapor

struct APIOrder: Codable, Content {
    var createdAt: Date?
    var updatedAt: Date?
    var vouchers: [APIVoucher]
    var address: APIAddress
    var deliveryStatus: TransportationStatus
    var orderStatus: OrderStatus
    var items: [APIOrderItem]
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case vouchers = "vouchers_ids"
        case address
        case deliveryStatus = "delivery_status"
        case orderStatus = "order_status"
        case items
    }
}

extension APIOrder {
    init(from model: Order, address: Address, items: [APIOrderItem]) {
        createdAt = model.createdAt
        updatedAt = model.updatedAt
        vouchers = []
        self.address = APIAddress(from: address)
        deliveryStatus = TransportationStatus(rawValue: model.deliveryStatus) ?? .pending
        orderStatus = OrderStatus(rawValue: model.orderStatus) ?? .confirmed
        self.items = items
    }
}
