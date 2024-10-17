import Foundation

struct APICreateReview: Codable {
    let orderId: String
    let productId: String
    let rate: Int
    let title: String
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case productId = "product_id"
        case rate
        case title
        case text
    }
}
