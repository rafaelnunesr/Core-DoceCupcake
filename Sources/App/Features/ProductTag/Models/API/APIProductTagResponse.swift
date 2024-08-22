import Vapor

struct APIProductTagResponse: Content {
    let code: String
    let description: String
}

extension APIProductTagResponse {
    init(from tag: InternalProductTagModel) {
        code = tag.code
        description = tag.description
    }
}
