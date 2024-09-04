import Vapor

struct APIProductTag: Content, Codable {
    let code: String
    let description: String
}

extension APIProductTag{
    init(from model: ProductTag) {
        code = model.code
        description = model.description
    }
}
