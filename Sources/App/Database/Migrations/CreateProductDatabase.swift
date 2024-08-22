import Foundation
import Fluent

struct CreateProductDatabase: AsyncMigration {
    private let databaseName = "product"
    
    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field("created_at", .datetime)
            .field("product_id", .string, .required)
            .field("code", .string, .required)
            .field("name", .string, .required)
            .field("description", .string, .required)
            .field("original_price", .double)
            .field("current_price", .double, .required)
            .field("current_discount", .double)
            .field("stock_count", .double, .required)
            .field("launch_date", .datetime)
            .field("tags", .string, .references("product_tag", "code"))
            .field("allergic_tags", .string, .references("product_tag", "code"))
            .field("nutritional_informations", .string) // update this
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
