import Vapor

struct ProductTagListResponse: Content {
    let count: Int
    let tags: [APIProductTag]
}
