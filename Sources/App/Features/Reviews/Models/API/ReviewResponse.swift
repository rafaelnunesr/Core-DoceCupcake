import Vapor

struct ReviewResponse: Content, Codable {
    let id: String
    let createdAt: Date?
    let orderId: String
    let userName: String
    let productId: String
    let rate: Int
    let title: String
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case orderId = "order_id"
        case userName = "user_name"
        case productId = "product_id"
        case rate
        case title
        case text
    }
}

extension ReviewResponse {
    init(from review: Review) {
        id = review.id?.uuidString ?? .empty
        createdAt = review.createdAt
        orderId = review.orderId.uuidString
        userName = review.userName
        productId = review.productId.uuidString
        rate = review.rate
        title = review.text
        text = review.text
    }
}
