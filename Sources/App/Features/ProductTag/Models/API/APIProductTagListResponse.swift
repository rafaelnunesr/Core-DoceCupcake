import Vapor

struct APIProductTagListResponse: Content, Sendable {
    let count: Int
    let tags: [APIProductTagModel]
}
