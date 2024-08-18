import Fluent

struct CreateUserDatabase: AsyncMigration {
    private let databaseName = "person"

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field("created_at", .datetime)
            .field("user_name", .string, .required)
            .field("email", .string, .required)
            .field("password", .string, .required)
            .field("state", .string, .required)
            .field("city", .string, .required)
            .field("address", .string, .required)
            .field("address_complement", .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
