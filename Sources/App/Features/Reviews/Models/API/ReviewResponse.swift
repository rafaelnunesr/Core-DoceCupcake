import Vapor

struct ReviewResponse: Content {
    let id: String
    let createdAt: Date?
    let orderId: String
    let userId: String
    let productId: String
    let rate: Int
    let title: String
    let text: String
}

extension ReviewResponse {
    init(from review: Review) {
        id = review.id?.uuidString ?? .empty
        createdAt = review.createdAt
        orderId = review.orderId.uuidString
        userId = review.userId.uuidString
        productId = review.productId.uuidString
        rate = review.rate
        title = review.text
        text = review.text
    }
}
