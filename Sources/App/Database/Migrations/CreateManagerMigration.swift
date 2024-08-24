import Fluent

struct CreateManagerMigration: AsyncMigration {
    private let databaseName = "manager"

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field("created_at", .datetime)
            .field("user_name", .string, .required)
            .field("email", .string, .required)
            .field("password", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
