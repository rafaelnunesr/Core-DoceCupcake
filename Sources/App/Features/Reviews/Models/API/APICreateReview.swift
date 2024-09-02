import Foundation

struct APICreateReview: Codable {
    let userId: String
    let orderId: String
    let productId: String
    let rate: Int
    let title: String
    let text: String
}
