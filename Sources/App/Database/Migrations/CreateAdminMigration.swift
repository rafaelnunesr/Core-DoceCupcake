import Fluent

struct CreateAdminMigration: AsyncMigration {
    private let databaseName = AdminDbField.schema.rawValue

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field(AdminDbField.createdAt.fieldKey, .datetime)
            .field(AdminDbField.userName.fieldKey, .string, .required)
            .field(AdminDbField.email.fieldKey, .string, .required)
            .field(AdminDbField.password.fieldKey, .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
