import Fluent
import Vapor

enum ProductTagDbField: String {
    case schema = "product_tag"
    case code
    case description
    
    var fieldKey: FieldKey {
        return FieldKey(stringLiteral: self.rawValue)
    }
}

final class ProductTag: DatabaseModelProtocol, Sendable {
    static let schema = ProductTagDbField.schema.rawValue

    @ID(key: .id)
    var id: UUID?

    @Field(key: ProductTagDbField.code.fieldKey)
    var code: String

    @Field(key: ProductTagDbField.description.fieldKey)
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
