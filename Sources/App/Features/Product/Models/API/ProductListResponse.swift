import Vapor

struct ProductListResponse: Content {
    var count: Int
    var products: [ProductResponse]
}
