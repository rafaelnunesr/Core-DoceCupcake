struct APIOrderUpdate: Codable {
    var orderNumber: Int
    var orderStatus: OrderStatus
    var deliveryStatus: TransportationStatus
    
    enum CodingKeys: String, CodingKey {
        case orderNumber = "order_number"
        case orderStatus = "order_status"
        case deliveryStatus = "delivery_status"
    }
}
