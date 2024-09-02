import Vapor

struct APIProductTag: Content, Codable, Sendable {
    let code: String
    let description: String
}

extension APIProductTag{
    init(from model: ProductTag) {
        code = model.code
        description = model.description
    }
}
