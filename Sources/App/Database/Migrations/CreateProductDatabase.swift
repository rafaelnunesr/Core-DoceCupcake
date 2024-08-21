import Fluent

struct CreateProductDatabase: AsyncMigration {
    private let databaseName = "product"

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field("created_at", .datetime)
            .field("name", .string, .required)
            .field("description", .string, .required)
            .field("original_price", .double, .required)
            .field("current_price", .double, .required)
            .field("current_discount", .double)
            .field("stock_count", .double, .required)
            .field("launch_date", .datetime)
            .field("tags", .string) // update this
            .field("allergic_tags", .string) // update this
            .field("nutritional_informations", .string) // update this
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
