import Foundation

struct APICreateReview: Codable {
    let userId: String
    let orderId: String
    let productCode: String
    let rate: Int
    let title: String
    let text: String
}
