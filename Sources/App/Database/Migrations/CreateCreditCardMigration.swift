import Fluent

struct CreateCardMigration: AsyncMigration {
    private let databaseName = "credit_card"

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field("created_at", .datetime)
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("card_holder_name", .string, .required)
            .field("card_number", .string, .required)
            .field("last_digits", .string, .required)
            .field("expiry_month", .int, .required)
            .field("expiry_year", .int, .required)
            .field("cvv", .string, .required)
            .unique(on: "card_number")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
