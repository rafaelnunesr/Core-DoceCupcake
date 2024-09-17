enum TransportationStatus: Int, Codable {
    case pending = 1
    case confirmed
    case dispatched
    case outForDelivery
    case delivered
    case cancelled
    case failed

    var description: String {
        switch self {
        case .pending:
            return "Your order is pending confirmation."
        case .confirmed:
            return "Your order has been confirmed."
        case .dispatched:
            return "Your order has been dispatched from the warehouse."
        case .outForDelivery:
            return "Your order is on its way."
        case .delivered:
            return "Your order has been successfully delivered."
        case .cancelled:
            return "Your order has been cancelled."
        case .failed:
            return "Delivery failed, please contact support."
        }
    }
}

