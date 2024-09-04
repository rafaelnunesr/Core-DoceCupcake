//import Fluent
//
//struct CreateSessionMigration: AsyncMigration {
//    private let databaseName = SessionDbField.schema.rawValue
//
//    func prepare(on database: Database) async throws {
//        try await database.schema(databaseName)
//            .id()
//            .field(SessionDbField.createdAt.fieldKey, .datetime)
//            .field(SessionDbField.userId.fieldKey, .uuid)
//            .field(SessionDbField.token.fieldKey, .string, .required)
//            .field(SessionDbField.isAdmin.fieldKey, .bool, .required)
//            .unique(on: SessionDbField.token.fieldKey)
//            .unique(on: SessionDbField.userId.fieldKey)
//            .create()
//    }
//
//    func revert(on database: Database) async throws {
//        try await database.schema(databaseName).delete()
//    }
//}
