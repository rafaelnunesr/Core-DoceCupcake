import Vapor

struct APIProductResponse: Content {
    let id: String
    let name: String
    let description: String
    let originalPrice: Double
    let currentPrice: Double
    let currentDiscount: Double
    let stockCount: Int
    let launchDate: String
    let tags: [APIProductTagResponse]
    let allergicTags: [APIProductTagResponse]
    let nutritionalInformations: [APINutritionalInformation]

    enum CodingKeys: String, CodingKey {
        case id
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
