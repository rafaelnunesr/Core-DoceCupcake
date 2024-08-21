import Vapor

struct APIProductTagResponse: Content {
    let id: UUID?
    let code: String
    let description: String
}

extension APIProductTagResponse {
    init(from tag: InternalProductTagModel) {
        id = tag.id
        code = tag.code
        description = tag.description
    }
}
