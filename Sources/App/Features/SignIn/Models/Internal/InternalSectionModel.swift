import Fluent
import Vapor

final class InternalSectionModel: Model, Content {
    static let schema = "session"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Field(key: "user_id")
    var userId: UUID

    @Field(key: "token")
    var token: String

    @Field(key: "is_admin")
    var isAdmin: Bool

    internal init() { }

    init(id: UUID? = nil, 
         createdAt: Date? = nil,
         expiryDate: Date? = nil,
         userId: UUID,
         token: String,
         isAdmin: Bool) {
        self.id = id
        self.createdAt = createdAt
        self.userId = userId
        self.token = token
        self.isAdmin = isAdmin
    }
}
