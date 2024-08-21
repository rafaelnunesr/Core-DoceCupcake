import Vapor

struct APIReviewResponse: Content {
    let createdAt: Date?
    let orderId: UUID
    let userId: UUID
    let productId: UUID
    let rate: Int
    let title: String
    let text: String
}

extension APIReviewResponse {
    init(from review: InternalProductReview) {
        createdAt = review.createdAt
        orderId = review.orderId
        userId = review.userId
        productId = review.productId
        rate = review.rate
        title = review.text
        text = review.text
    }
}
