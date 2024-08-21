import Vapor

struct APIProductListResponse: Content {
    var count: Int
    var products: [APIProductResponse]
}
