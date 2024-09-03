import Fluent

struct CreateOrderMigration: AsyncMigration {
    private let databaseName = OrderDbField.schema.rawValue

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field(OrderDbField.createdAt.fieldKey, .datetime)
            .field(OrderDbField.updatedAt.fieldKey, .datetime)
            .field(OrderDbField.userId.fieldKey, .uuid, .required,
                .references(UsersDbField.schema.rawValue, UsersDbField.id.fieldKey))
            .field(OrderDbField.voucherCode.fieldKey, .string,
                .references(VoucherDbField.schema.rawValue, VoucherDbField.code.fieldKey))
            .field(OrderDbField.paymentId.fieldKey, .uuid, .required,
                .references(CreditCardDbField.schema.rawValue, CreditCardDbField.id.fieldKey))
            .field(OrderDbField.deliveryAddress.fieldKey, .string)
            .field(OrderDbField.deliveryStatus.fieldKey, .string) // change this
            .field(OrderDbField.orderStatus.fieldKey, .string) // change this
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
