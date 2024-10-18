import Fluent
import SQLKit

struct CreateOrderMigration: AsyncMigration {
    private let databaseName = OrderDbField.schema.rawValue
    
    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field(OrderDbField.createdAt.fieldKey, .datetime)
            .field(OrderDbField.updatedAt.fieldKey, .datetime)
            .field(OrderDbField.number.fieldKey, .string, .required)
            .field(OrderDbField.userId.fieldKey, .uuid, .required,
                   .references(UsersDbField.schema.rawValue, UsersDbField.id.fieldKey))
            .field(OrderDbField.voucherCode.fieldKey, .string,
                   .references(VoucherDbField.schema.rawValue, VoucherDbField.code.fieldKey))
            .field(OrderDbField.paymentId.fieldKey, .uuid, .required,
                   .references(CreditCardDbField.schema.rawValue, CreditCardDbField.id.fieldKey))
            .field(OrderDbField.total.fieldKey, .double, .required)
            .field(OrderDbField.deliveryFee.fieldKey, .double, .required)
            .field(OrderDbField.subtotal.fieldKey, .double, .required)
            .field(OrderDbField.discount.fieldKey, .double, .required)
            .field(OrderDbField.addressId.fieldKey, .uuid, .required,
                   .references(AddressDbField.schema.rawValue, AddressDbField.id.fieldKey))
            .field(OrderDbField.orderStatus.fieldKey, .int, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
