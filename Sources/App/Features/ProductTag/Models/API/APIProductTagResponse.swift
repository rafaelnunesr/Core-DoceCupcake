import Vapor

struct APIProductTagModel: Content, Codable, Sendable {
    let code: String
    let description: String
}

extension APIProductTagModel{
    init(from model: InternalProductTagModel) {
        code = model.code
        description = model.description
    }
}
