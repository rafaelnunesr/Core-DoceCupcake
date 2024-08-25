import Fluent

struct CreateVoucherMigration: AsyncMigration {
    private let databaseName = "voucher"

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field("created_at", .datetime)
            .field("expiry_date", .datetime)
            .field("code", .string, .required)
            .field("percentage_discount", .double)
            .field("monetary_discount", .double)
            .field("availability_count", .int)
            .unique(on: "code")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
