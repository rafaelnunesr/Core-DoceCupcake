enum DeliveryStatus: Int, Codable {
    case pending = 1
    case shipped
    case outForDelivery
    case delivered
    case failedDelivery
    case returnedToSender
}
