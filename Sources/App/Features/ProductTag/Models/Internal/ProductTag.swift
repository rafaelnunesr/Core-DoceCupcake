import Fluent
import Vapor

final class ProductTag: DatabaseModelProtocol, Sendable {
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

extension ProductTag {
    static var codeKey: KeyPath<ProductTag, Field<String>> {
        \ProductTag.$code
    }

    static var idKey: KeyPath<ProductTag, IDProperty<ProductTag, UUID>> {
        \ProductTag.$id
    }
}

extension ProductTag {
    convenience init(from model: APIProductTag) {
        self.init(code: model.code,
                  description: model.description
        )
    }
}
