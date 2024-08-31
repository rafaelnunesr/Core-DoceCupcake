import Fluent

struct CreateSessionMigration: AsyncMigration {
    private let databaseName = "session"

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field("created_at", .datetime)
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("token", .string, .required)
            .field("is_admin", .bool, .required)
            .unique(on: "token")
            .unique(on: "user_id")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
