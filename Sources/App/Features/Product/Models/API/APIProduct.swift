import Foundation
import Vapor

struct APIProduct: Codable, Content {
    let code: String
    let name: String
    let description: String
    var label: String?
    var imageUrl: String?
    let currentPrice: Double
    var originalPrice: Double?
    var voucherCode: String?
    let stockCount: Double
    let launchDate: Date?
    var tags: [APITag]
    var allergicInfo: AllergicInfo
    var nutritionalInformations: [APINutritionalInformation]
    let isNew: Bool
    let isHighlightSale: Bool
    let isHighlightNew: Bool
    
    enum CodingKeys: String, CodingKey {
        case code
        case name
        case description
        case label
        case imageUrl = "image_url"
        case currentPrice = "current_price"
        case originalPrice = "original_price"
        case voucherCode = "voucher_code"
        case stockCount = "stock_count"
        case launchDate = "launch_date"
        case tags
        case allergicInfo = "allergic_info"
        case nutritionalInformations = "nutritional_informations"
        case isNew = "is_new"
        case isHighlightSale = "is_highlight_sale"
        case isHighlightNew = "is_highlight_new"
    }
}

extension APIProduct {
    init(from model: Product, nutritionalInfos: [APINutritionalInformation] = []) {
        code = model.code
        name = model.name
        description = model.description
        imageUrl = model.imageUrl
        label = model.label
        currentPrice = model.currentPrice
        originalPrice = model.originalPrice
        voucherCode = model.voucherCode
        stockCount = model.stockCount
        launchDate = model.launchDate
        tags = model.tags.map { APITag(code: $0) }
        allergicInfo = model.allergicInfo
        nutritionalInformations = nutritionalInfos
        isNew = model.isNew
        isHighlightNew = model.isHighlightedNew
        isHighlightSale = model.isHighlightedSale
    }
}
