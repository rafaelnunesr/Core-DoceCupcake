import Fluent
import Vapor

enum UsersDbField: String {
    case schema = "review"
    
    case id
    case createdAt = "created_at"
    case userName = "user_name"
    case email
    case password
    case imageUrl = "image_url"
    case state
    case city
    case address
    case addressComplement = "address_complement"
    
    var fieldKey: FieldKey {
        return FieldKey(stringLiteral: self.rawValue)
    }
}

final class User: Model, @unchecked Sendable {
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

    @Field(key: UsersDbField.state.fieldKey)
    var state: String

    @Field(key: UsersDbField.city.fieldKey)
    var city: String

    @Field(key: UsersDbField.address.fieldKey)
    var address: String

    @OptionalField(key: UsersDbField.addressComplement.fieldKey)
    var addressComplement: String?

    internal init() {}

    init(id: UUID? = nil, 
         createdAt: Date? = nil,
         userName: String,
         email: String,
         password: String,
         imageUrl: String? = nil,
         state: String,
         city: String,
         address: String,
         addressComplement: String? = nil) {
        self.id = id
        self.createdAt = createdAt
        self.userName = userName
        self.email = email
        self.password = password
        self.imageUrl = imageUrl
        self.state = state
        self.city = city
        self.address = address
        self.addressComplement = addressComplement
    }
}

extension User {
    convenience init(from model: SignUpUserRequest) {
        self.init(userName: model.userName,
                  email: model.email,
                  password: model.password,
                  imageUrl: model.imageUrl,
                  state: model.state,
                  city: model.city,
                  address: model.address,
                  addressComplement: model.addressComplement)
    }
}
