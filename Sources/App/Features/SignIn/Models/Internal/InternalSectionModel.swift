import Fluent
import Vapor

final class InternalSectionModel: Model, Content {
    static let schema = "section"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "expiry_date", on: .create)
    var expiryDate: Date?

    @Field(key: "user_id")
    var userId: UUID

    @Field(key: "token")
    var token: String

    internal init() { }

    init(id: UUID? = nil, 
         createdAt: Date? = nil,
         expiryDate: Date? = nil,
         userId: UUID,
         token: String) {
        self.id = id
        self.createdAt = createdAt
        self.expiryDate = expiryDate
        self.userId = userId
        self.token = token
    }
}
