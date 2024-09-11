import Foundation
import Vapor

struct APIProductResponse: Codable, Content {
    let code: String
    let name: String
    let description: String
    var imageUrl: String?
    let currentPrice: Double
    var originalPrice: Double?
    let stockCount: Double
    let launchDate: Date?
    var tags: [APIProductTag]
    var allergicTags: [APIProductTag]
    var nutritionalInformations: [APINutritionalInformation]
    let isNew: Bool
    
    enum CodingKeys: String, CodingKey {
        case code
        case name
        case description
        case imageUrl = "image_url"
        case currentPrice = "current_price"
        case originalPrice = "original_price"
        case stockCount = "stock_count"
        case launchDate = "launch_date"
        case tags
        case allergicTags = "allergic_tags"
        case nutritionalInformations = "nutritional_informations"
        case isNew = "is_new"
    }
}

extension APIProductResponse {
    init(from model: Product,
         tags: [APIProductTag],
         allergicTags: [APIProductTag],
         nutritionalInfos: [APINutritionalInformation]) {
        code = model.code
        name = model.name
        description = model.description
        imageUrl = model.imageUrl
        currentPrice = model.currentPrice
        originalPrice = model.originalPrice
        stockCount = model.stockCount
        launchDate = model.launchDate
        self.tags = tags
        self.allergicTags = allergicTags
        nutritionalInformations = nutritionalInfos
        isNew = model.isNew
    }
}

