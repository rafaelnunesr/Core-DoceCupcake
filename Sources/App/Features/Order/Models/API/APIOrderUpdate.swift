import Vapor

struct APIOrderUpdate: Codable, Content {
    var orderNumber: String
    var orderStatus: OrderStatus
    
    enum CodingKeys: String, CodingKey {
        case orderNumber = "order_number"
        case orderStatus = "order_status"
    }
}
