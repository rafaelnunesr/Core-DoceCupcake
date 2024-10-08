import Vapor

struct APIOrderUpdate: Codable, Content {
    var orderNumber: String
    var orderStatus: OrderStatus
    var deliveryStatus: TransportationStatus
    
    enum CodingKeys: String, CodingKey {
        case orderNumber = "order_number"
        case orderStatus = "order_status"
        case deliveryStatus = "delivery_status"
    }
}
