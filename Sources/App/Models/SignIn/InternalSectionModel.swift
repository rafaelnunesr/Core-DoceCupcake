import Fluent
import Vapor

final class InternalSectionModel: Model, Content {
    static let schema = "sectionModel"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "created_at")
    var createdAt: String

    @Field(key: "expiry_date")
    var expiryDate: String

    @Field(key: "user_id")
    var userId: String

    @Field(key: "token")
    var token: String

    internal init() { }

    init(id: UUID? = nil, createdAt: String, expiryDate: String, userId: String, token: String) {
        self.id = id
        self.createdAt = createdAt
        self.expiryDate = expiryDate
        self.userId = userId
        self.token = token
    }
}
