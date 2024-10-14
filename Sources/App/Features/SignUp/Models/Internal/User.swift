import Fluent
import Vapor

enum UsersDbField: String {
    case schema = "users"
    
    case id
    case createdAt = "created_at"
    case userName = "user_name"
    case email
    case password
    case imageUrl = "image_url"
    case phoneNumber = "phone_number"
    
    var fieldKey: FieldKey {
        return FieldKey(stringLiteral: self.rawValue)
    }
}

final class User: Model {
    static let schema = UsersDbField.schema.rawValue

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: UsersDbField.createdAt.fieldKey, on: .create)
    var createdAt: Date?

    @Field(key: UsersDbField.userName.fieldKey)
    var userName: String

    @Field(key: UsersDbField.email.fieldKey)
    var email: String

    @Field(key: UsersDbField.password.fieldKey)
    var password: String
    
    @OptionalField(key: UsersDbField.imageUrl.fieldKey)
    var imageUrl: String?
    
    @Field(key: UsersDbField.phoneNumber.fieldKey)
    var phoneNumber: String
    
    internal init() {}

    init(id: UUID? = nil, 
         createdAt: Date? = nil,
         userName: String,
         email: String,
         password: String,
         imageUrl: String? = nil,
         phoneNumber: String) {
        self.id = id
        self.createdAt = createdAt
        self.userName = userName
        self.email = email
        self.password = password
        self.imageUrl = imageUrl
        self.phoneNumber = phoneNumber
    }
}

extension User {
    convenience init(from model: SignUpUserRequest) {
        self.init(userName: model.userName,
                  email: model.email,
                  password: model.password,
                  imageUrl: model.imageUrl,
                  phoneNumber: model.phoneNumber)
    }
}
