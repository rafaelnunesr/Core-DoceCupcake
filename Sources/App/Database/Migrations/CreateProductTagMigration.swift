import Fluent

struct CreateProductTagMigration: AsyncMigration {
    private let databaseName = ProductTagDbField.schema.rawValue

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field(ProductTagDbField.code.fieldKey, .string, .required)
            .field(ProductTagDbField.description.fieldKey, .string, .required)
            .unique(on: ProductTagDbField.code.fieldKey)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
