import Foundation

struct APIProductModel: Codable {
    let id: String
    let code: String
    let name: String
    let description: String
    var originalPrice: Double?
    let currentPrice: Double
    var currentDiscount: Double?
    let stockCount: Double
    var launchDate: Date?
    var tags: [String]
    var allergicTags: [String]
    var nutritionalInformations: String
}
