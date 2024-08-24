import Foundation
import Fluent

struct CreateNutritionalDatabase: AsyncMigration {
    private let databaseName = "nutritional"

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field("name", .string, .required)
            .field("quantity_description", .string, .required)
            .field("daily_representation", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
