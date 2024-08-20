import Foundation

struct ProductModel {
    let id: String
    let name: String
    let description: String
    let originalPrice: Double
    let currentPrice: Double
    let currentDiscount: Double
    let stockCount: Int
    let launchDate: String
    let tags: [ProductTag]
    let allergicTags: [ProductAllergicTag]
    let nutritionalInformations: [NutritionalInformation]
}
