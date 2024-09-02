import Vapor

struct ProductTagListResponse: Content, Sendable {
    let count: Int
    let tags: [APIProductTag]
}
