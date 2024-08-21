import Fluent
import Vapor

final class InternalProductTagModel: Model, Content {
    static let schema = "product_tag"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "code")
    var code: String

    @Field(key: "description")
    var description: String

    internal init() {}

    init(id: UUID? = nil, code: String, description: String) {
        self.id = id
        self.code = code
        self.description = description
    }
}
