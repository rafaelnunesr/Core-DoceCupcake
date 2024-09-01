import Vapor

struct APIOrderModel: Codable, Content {
    var createdAt: Date?
    var updatedAt: Date?
    var products: [String]
    var vouchersIds: [UUID]
    var address: String
    var transportationStatus: [String]
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case products
        case vouchersIds = "vouchers_ids"
        case address
        case transportationStatus = "transportation_status"
    }
}
