import Fluent

struct CreateAddressMigration: AsyncMigration {
    private let databaseName = AddressDbField.schema.rawValue

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field(AddressDbField.createdAt.fieldKey, .datetime)
            .field(AddressDbField.userId.fieldKey, .uuid, .required, 
                .references(UsersDbField.schema.rawValue, UsersDbField.id.fieldKey))
            .field(AddressDbField.streetName.fieldKey, .string, .required)
            .field(AddressDbField.number.fieldKey, .string, .required)
            .field(AddressDbField.zipCode.fieldKey, .string, .required)
            .field(AddressDbField.complementary.fieldKey, .string)
            .field(AddressDbField.state.fieldKey, .string, .required)
            .field(AddressDbField.city.fieldKey, .string, .required)
            .field(AddressDbField.country.fieldKey, .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
