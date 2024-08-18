import Fluent
import Vapor

final class Person: Model {
    static let schema = "person"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Field(key: "user_name")
    var userName: String

    @Field(key: "email")
    var email: String

    @Field(key: "password")
    var password: String

    @Field(key: "state")
    var state: String

    @Field(key: "city")
    var city: String

    @Field(key: "address")
    var address: String

    @OptionalField(key: "address_complement")
    var addressComplement: String?

    internal init() {}

    init(id: UUID? = nil, 
         createdAt: Date? = nil,
         userName: String,
         email: String,
         password: String, 
         state: String,
         city: String,
         address: String,
         addressComplement: String? = nil) {
        self.id = id
        self.createdAt = createdAt
        self.userName = userName
        self.email = email
        self.password = password
        self.state = state
        self.city = city
        self.address = address
        self.addressComplement = addressComplement
    }
}

extension Person {
    convenience init(from model: SignUpModel) {
        self.init(userName: model.userName,
                  email: model.email,
                  password: model.password,
                  state: model.state,
                  city: model.city,
                  address: model.address,
                  addressComplement: model.addressComplement)
    }
}
