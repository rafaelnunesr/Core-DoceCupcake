import Foundation
import Vapor

struct APIProduct: Codable, Content {
    let code: String
    let name: String
    let description: String
    var imageUrl: String?
    let currentPrice: Double
    var originalPrice: Double?
    var voucherCode: String?
    let stockCount: Double
    let launchDate: Date?
    var tags: [APITag]
    var allergicTags: [APITag]
    var nutritionalInformations: [APINutritionalInformation]
    let isNew: Bool
    
    enum CodingKeys: String, CodingKey {
        case code
        case name
        case description
        case imageUrl = "image_url"
        case currentPrice = "current_price"
        case originalPrice = "original_price"
        case voucherCode = "voucher_code"
        case stockCount = "stock_count"
        case launchDate = "launch_date"
        case tags
        case allergicTags = "allergic_tags"
        case nutritionalInformations = "nutritional_informations"
        case isNew = "is_new"
    }
}

extension APIProduct {
    init(from model: Product, nutritionalInfos: [APINutritionalInformation]) {
        code = model.code
        name = model.name
        description = model.description
        imageUrl = model.imageUrl
        currentPrice = model.currentPrice
        originalPrice = model.originalPrice
        voucherCode = model.voucherCode
        stockCount = model.stockCount
        launchDate = model.launchDate
        tags = model.tags.map { APITag(code: $0) }
        allergicTags = model.allergicTags.map { APITag(code: $0) }
        nutritionalInformations = nutritionalInfos
        isNew = model.isNew
    }
}
