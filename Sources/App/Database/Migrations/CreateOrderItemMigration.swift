import Fluent

struct CreateOrderItemMigration: AsyncMigration {
    private let databaseName = OrderItemDbField.schema.rawValue
    
    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field(OrderItemDbField.orderId.fieldKey, .uuid, .required,
                   .references(OrderDbField.schema.rawValue, OrderDbField.id.fieldKey))
            .field(OrderItemDbField.productId.fieldKey, .uuid, .required,
                   .references(ProductDbField.schema.rawValue, ProductDbField.id.fieldKey))
            .field(OrderItemDbField.quantity.fieldKey, .double, .required)
            .field(OrderItemDbField.unitValue.fieldKey, .double, .required)
            .field(OrderItemDbField.orderStatus.fieldKey, .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
