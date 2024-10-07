import Foundation

struct APICreateReview: Codable {
    let orderId: String
    let productId: String
    let rate: Int
    let title: String
    let text: String
}
