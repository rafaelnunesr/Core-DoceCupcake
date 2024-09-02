import Vapor

struct ProductResponse: Content {
    var id: String
    let name: String
    let description: String
    var originalPrice: Double?
    let currentPrice: Double
    var currentDiscount: Double?
    let stockCount: Double
    let launchDate: Date?
    var tags: [APIProductTag]
    var allergicTags: [APIProductTag]
    var nutritionalInformations: [APINutritionalInformation]

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

extension ProductResponse {
    init(from product: Product) {
        id = product.productId
        name = product.name
        description = product.description
        originalPrice = product.originalPrice
        currentPrice = product.currentPrice
        currentDiscount = product.currentDiscount
        stockCount = product.stockCount
        launchDate = product.launchDate
        tags = [] // fix this
        allergicTags = [] // fix this
        nutritionalInformations = [] // fix this
    }
}
