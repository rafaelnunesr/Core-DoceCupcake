import Fluent
import Vapor

enum AdminDbField: String {
    case schema = "admin"
    case createdAt = "created_at"
    case userName = "user_name"
    case email
    case password
    
    var fieldKey: FieldKey {
        return FieldKey(stringLiteral: self.rawValue)
    }
}

final class Admin: Model {
    static let schema = AdminDbField.schema.rawValue

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: AdminDbField.createdAt.fieldKey, on: .create)
    var createdAt: Date?

    @Field(key: AdminDbField.userName.fieldKey)
    var userName: String

    @Field(key: AdminDbField.email.fieldKey)
    var email: String

    @Field(key: AdminDbField.password.fieldKey)
    var password: String

    internal init() {}

    init(id: UUID? = nil,
         createdAt: Date? = nil,
         userName: String,
         email: String,
         password: String) {
        self.id = id
        self.createdAt = createdAt
        self.userName = userName
        self.email = email
        self.password = password
    }
}

extension Admin {
    convenience init(from manager: SignUpAdminRequest) {
        self.init(userName: manager.userName, email: manager.email, password: manager.password)
    }
}



//
//final class Admin: Model {
//    static let schema = "admin"
//
//    @ID(key: .id)
//    var id: UUID?
//
//    @Timestamp(key: "created_at", on: .create)
//    var createdAt: Date?
//
//    @Field(key: "user_name")
//    var userName: String
//
//    @Field(key: "email")
//    var email: String
//
//    @Field(key: "password")
//    var password: String
//
//    internal init() {}
//
//    init(id: UUID? = nil,
//         createdAt: Date? = nil,
//         userName: String,
//         email: String,
//         password: String) {
//        self.id = id
//        self.createdAt = createdAt
//        self.userName = userName
//        self.email = email
//        self.password = password
//    }
//}
//
//extension Admin {
//    convenience init(from manager: SignUpAdminRequest) {
//        self.init(userName: manager.userName, email: manager.email, password: manager.password)
//    }
//}
