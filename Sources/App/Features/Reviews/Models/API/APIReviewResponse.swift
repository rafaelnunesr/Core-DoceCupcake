import Vapor

struct APIReviewResponse: Content {
    let createdAt: Date?
    let orderId: String
    let userId: String
    let productId: String
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
