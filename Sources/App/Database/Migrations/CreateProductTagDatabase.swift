import Fluent

struct CreateProductTagDatabase: AsyncMigration {
    private let databaseName = "product_tag"

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field("code", .string, .required)
            .field("description", .string, .required)
            .unique(on: "code")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
