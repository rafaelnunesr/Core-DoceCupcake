import Fluent
import Vapor

enum SessionDbField: String {
    case schema = "session"
    
    case createdAt = "created_at"
    case userId = "user_id"
    case token
    case isAdmin = "is_admin"
    
    var fieldKey: FieldKey {
        return FieldKey(stringLiteral: self.rawValue)
    }
}

final class InternalSectionModel: Model, Content {
    static let schema = SessionDbField.schema.rawValue

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: SessionDbField.createdAt.fieldKey, on: .create)
    var createdAt: Date?

    @Field(key: SessionDbField.userId.fieldKey)
    var userId: UUID

    @Field(key: SessionDbField.token.fieldKey)
    var token: String

    @Field(key: SessionDbField.isAdmin.fieldKey)
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
