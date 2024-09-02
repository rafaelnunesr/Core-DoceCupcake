import Fluent

struct CreateReviewMigration: AsyncMigration {
    private let databaseName = "review"

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field("created_at", .datetime)
            .field("order_id", .string, .required) // change relationship
            .field("user_id", .string, .required) // change relationship
            .field("product_id", .string, .required) // change relationship
            .field("rate", .int, .required)
            .field("title", .string, .required)
            .field("text", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
