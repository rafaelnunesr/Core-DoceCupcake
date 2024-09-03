import Vapor

struct ReviewResponse: Content {
    let createdAt: Date?
    let orderId: String
    let userId: String
    let productCode: String
    let rate: Int
    let title: String
    let text: String
}

extension ReviewResponse {
    init(from review: Review) {
        createdAt = review.createdAt
        orderId = review.orderId
        userId = review.userId
        productCode = review.productCode
        rate = review.rate
        title = review.text
        text = review.text
    }
}
