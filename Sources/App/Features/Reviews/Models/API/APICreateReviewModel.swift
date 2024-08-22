import Foundation

struct APICreateReviewModel: Codable {
    let userId: String
    let orderId: String
    let productId: String
    let rate: Int
    let title: String
    let text: String
}
