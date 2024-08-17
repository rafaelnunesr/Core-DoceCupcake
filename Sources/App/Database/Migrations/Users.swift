import Fluent

struct CreateUsersDatabase: AsyncMigration {
    private let databaseName = "users"

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
