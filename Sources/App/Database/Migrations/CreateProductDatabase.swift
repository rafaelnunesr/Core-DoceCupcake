import Foundation
import Fluent

struct CreateProductDatabase: AsyncMigration {
    private let databaseName = "product"
    
    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field("product_id", .string, .required)
            .field("code", .string, .required)
            .field("created_at", .datetime)
            .field("name", .string, .required)
            .field("description", .string, .required)
            .field("current_price", .double, .required)
            .field("original_price", .double)
            .field("current_discount", .double)
            .field("stock_count", .double, .required)
            .field("launch_date", .datetime)
            .field("tags", .array(of: .string), .required)
            .field("allergic_tags", .array(of: .string), .required)
            .field("nutritional_ids", .array(of: .uuid), .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
