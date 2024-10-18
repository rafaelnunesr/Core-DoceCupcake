enum OrderStatus: Int, Codable {
    case orderPlaced = 1
    case paymentApproved
    case preparing
    case outForDelivery
    case delivered
    case cancelled
}
