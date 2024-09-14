enum TransportationStatus: String, Codable {
    case pending = "Pending"
    case confirmed = "Confirmed"
    case dispatched = "Dispatched"
    case outForDelivery = "Out for Delivery"
    case delivered = "Delivered"
    case cancelled = "Cancelled"
    case failed = "Failed"

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

