import Vapor

struct APIProductTagListResponse: Content {
    let count: Int
    let tags: [APIProductTagModel]
}
