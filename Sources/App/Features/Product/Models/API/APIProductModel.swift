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
    var launchDate: String
    var tags: [APITagModel]
    var allergicTags: [APITagModel]
    var nutritionalInformations: [APINutritionalInformation]

    enum CodingKeys: String, CodingKey {
        case id = "product_id"
        case code
        case name
        case description
        case originalPrice = "original_price"
        case currentPrice = "current_price"
        case currentDiscount = "current_discount"
        case stockCount = "stock_count"
        case launchDate = "launch_date"
        case tags
        case allergicTags = "allergic_tags"
        case nutritionalInformations = "nutritional_informations"
    }
}
