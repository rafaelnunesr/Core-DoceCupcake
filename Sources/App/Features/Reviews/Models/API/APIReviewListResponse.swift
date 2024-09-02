import Vapor

struct APIReviewListResponse: Content {
    let count: Int
    let reviews: [ReviewResponse]
}
