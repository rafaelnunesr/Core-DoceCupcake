import Fluent

struct CreateVoucherMigration: AsyncMigration {
    private let databaseName = VoucherDbField.schema.rawValue

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field(VoucherDbField.createdAt.fieldKey, .datetime)
            .field(VoucherDbField.expiryDate.fieldKey, .datetime)
            .field(VoucherDbField.code.fieldKey, .string, .required)
            .field(VoucherDbField.percentageDiscount.fieldKey, .double)
            .field(VoucherDbField.monetaryDiscount.fieldKey, .double)
            .field(VoucherDbField.availabilityCount.fieldKey, .int)
            .unique(on: VoucherDbField.code.fieldKey)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
