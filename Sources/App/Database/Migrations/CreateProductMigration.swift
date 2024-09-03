import Foundation
import Fluent

struct CreateProductMigration: AsyncMigration {
    private let databaseName = ProductDbField.schema.rawValue
    
    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field(ProductDbField.createdAt.fieldKey, .datetime)
            .field(ProductDbField.productId.fieldKey, .string, .required)
            .field(ProductDbField.code.fieldKey, .string, .required)
            .field(ProductDbField.name.fieldKey, .string, .required)
            .field(ProductDbField.description.fieldKey, .string, .required)
            .field(ProductDbField.imageUrl.fieldKey, .string)
            .field(ProductDbField.currentPrice.fieldKey, .double, .required)
            .field(ProductDbField.originalPrice.fieldKey, .double)
            .field(ProductDbField.voucherCode.fieldKey, .string,
                .references(VoucherDbField.schema.rawValue, VoucherDbField.code.fieldKey))
            .field(ProductDbField.stockCount.fieldKey, .double, .required)
            .field(ProductDbField.launchDate.fieldKey, .datetime)
            .field(ProductDbField.tags.fieldKey, .array(of: .string), .required)
            .field(ProductDbField.allergicTags.fieldKey, .array(of: .string), .required)
            .field(ProductDbField.nutritionalIds.fieldKey, .array(of: .uuid), .required)
            .field(ProductDbField.isNew.fieldKey, .bool, .required)
            .unique(on: ProductDbField.productId.fieldKey)
            .unique(on: ProductDbField.code.fieldKey)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
