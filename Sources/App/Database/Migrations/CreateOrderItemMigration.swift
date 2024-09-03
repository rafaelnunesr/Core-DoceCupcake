import Fluent

struct CreateOrderItemMigration: AsyncMigration {
    private let databaseName = OrderItemDbField.schema.rawValue

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field(OrderItemDbField.orderId.fieldKey, .uuid, .required,
                   .references(OrderDbField.schema.rawValue, OrderDbField.id.fieldKey))
            .field(OrderItemDbField.paymentId.fieldKey, .uuid, .required, 
                .references(CreditCardDbField.schema.rawValue, CreditCardDbField.id.fieldKey))
            .field(OrderItemDbField.quantity.fieldKey, .double, .required)
            .field(OrderItemDbField.deliveryStatus.fieldKey, .string, .required) // change this
            .field(OrderItemDbField.orderStatus.fieldKey, .string, .required) // change this
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
