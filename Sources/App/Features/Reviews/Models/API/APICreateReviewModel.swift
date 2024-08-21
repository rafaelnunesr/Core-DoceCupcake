import Foundation

struct APICreateReviewModel: Codable {
    let orderId: UUID
    let productId: UUID
    let rate: Int
    let title: String
    let text: String
}
