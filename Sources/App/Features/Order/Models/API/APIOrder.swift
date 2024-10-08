import Vapor

struct APIOrder: Codable, Content {
    var number: String
    var createdAt: Date?
    var updatedAt: Date?
    var address: APIAddress
    var deliveryStatus: TransportationStatus
    var orderStatus: OrderStatus
    var items: [APIOrderItem]
    var total: Double
    var deliveryFee: Double
    
    enum CodingKeys: String, CodingKey {
        case number = "number"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case address
        case deliveryStatus = "delivery_status"
        case orderStatus = "order_status"
        case items
        case total
        case deliveryFee = "delivery_fee"
    }
}

extension APIOrder {
    init(from model: Order, address: Address, items: [APIOrderItem]) {
        number = model.number
        createdAt = model.createdAt
        updatedAt = model.updatedAt
        self.address = APIAddress(from: address)
        deliveryStatus = TransportationStatus(rawValue: model.deliveryStatus) ?? .pending
        orderStatus = OrderStatus(rawValue: model.orderStatus) ?? .confirmed
        self.items = items
        self.total = model.total
        self.deliveryFee = model.deliveryFee
    }
}
