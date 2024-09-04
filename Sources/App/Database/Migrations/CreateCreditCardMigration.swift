import Fluent

struct CreateCreditCardMigration: AsyncMigration {
    private let databaseName = CreditCardDbField.schema.rawValue

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field(CreditCardDbField.createdAt.fieldKey, .datetime)
            .field(CreditCardDbField.userId.fieldKey, .uuid, .required, 
                .references(UsersDbField.schema.rawValue, UsersDbField.id.fieldKey))
            .field(CreditCardDbField.cardHolderName.fieldKey, .string, .required)
            .field(CreditCardDbField.cardNumber.fieldKey, .string, .required)
            .field(CreditCardDbField.lastDigits.fieldKey, .string, .required)
            .field(CreditCardDbField.expiryMonth.fieldKey, .int, .required)
            .field(CreditCardDbField.expiryYear.fieldKey, .int, .required)
            .field(CreditCardDbField.cvv.fieldKey, .string, .required)
            .unique(on: CreditCardDbField.cardNumber.fieldKey)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
