import Fluent

struct CreateSectionMigration: AsyncMigration {
    private let databaseName = "section"

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field("created_at", .datetime)
            .field("expiry_date", .datetime)
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("token", .string, .required)
            .unique(on: "token")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
