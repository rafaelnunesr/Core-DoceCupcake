import Fluent

struct CreateSectionDatabase: AsyncMigration {
    private let databaseName = "section"

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field("created_at", .string, .required)
            .field("expiry_date", .string, .required)
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("token", .string, .required)
            .unique(on: "token")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
