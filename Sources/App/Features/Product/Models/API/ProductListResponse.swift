import Vapor

struct ProductListResponse: Content {
    var count: Int
    var products: [APIProductResponse]
    var highlightedSaleProduct: APIProductResponse?
    var highlightedNewProduct: APIProductResponse?
    
    enum CodingKeys: String, CodingKey {
        case count
        case products
        case highlightedSaleProduct = "highlighted_sale"
        case highlightedNewProduct = "highlighted_new"
    }
}
