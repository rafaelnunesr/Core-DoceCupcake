import Fluent
import Vapor

final class Manager: Model {
    static let schema = "manager"

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
