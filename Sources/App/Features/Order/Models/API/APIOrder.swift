import Vapor

struct APIOrder: Codable, Content {
    var id: String?
    var number: String
    var createdAt: Date?
    var updatedAt: Date?
    var address: APIAddress
    var orderStatus: OrderStatus
    var items: [APIOrderItem]
    var discount: Double
    var total: Double
    var deliveryFee: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case number
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case address
        case orderStatus = "order_status"
        case items
        case discount
        case total
        case deliveryFee = "delivery_fee"
    }
}

extension APIOrder {
    init(from model: Order, address: Address, items: [APIOrderItem]) {
        id = model.id?.uuidString
        number = model.number
        createdAt = model.createdAt
        updatedAt = model.updatedAt
        self.address = APIAddress(from: address)
        orderStatus = OrderStatus(rawValue: model.orderStatus) ?? .orderPlaced
        self.items = items
        self.discount = model.discount
        self.total = model.total
        self.deliveryFee = model.deliveryFee
    }
}
