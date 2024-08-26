import Fluent
import Vapor

final class InternalProductTagModel: DatabaseModelProtocol {
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

extension InternalProductTagModel {
    static var codeKey: KeyPath<InternalProductTagModel, Field<String>> {
        \InternalProductTagModel.$code
    }

    static var idKey: KeyPath<InternalProductTagModel, IDProperty<InternalProductTagModel, UUID>> {
        \InternalProductTagModel.$id
    }
}

extension InternalProductTagModel {
    convenience init(from model: APIProductTagModel) {
        self.init(code: model.code,
                  description: model.description
        )
    }
}

//
//final class InternalProductTagModel: Model, Content {
//    static let schema = "product_tag"
//
//    @ID(key: .id)
//    var id: UUID?
//
//    @Field(key: "code")
//    var code: String
//
//    @Field(key: "description")
//    var description: String
//
//    internal init() {}
//
//    init(id: UUID? = nil, code: String, description: String) {
//        self.id = id
//        self.code = code
//        self.description = description
//    }
//}
//
//extension InternalProductTagModel {
//    convenience init(from model: APIProductTagModel) {
//        self.init(code: model.code,
//                  description: model.description
//        )
//    }
//}
