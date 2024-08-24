import Vapor

struct APIProductTagModel: Content, Codable {
    let code: String
    let description: String
}

extension APIProductTagModel{
    init(from model: InternalProductTagModel) {
        code = model.code
        description = model.description
    }
}
