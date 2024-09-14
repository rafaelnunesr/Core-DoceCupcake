import Fluent

struct CreateUsersMigration: AsyncMigration {
    private let databaseName = UsersDbField.schema.rawValue

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field(UsersDbField.createdAt.fieldKey, .datetime)
            .field(UsersDbField.userName.fieldKey, .string, .required)
            .field(UsersDbField.email.fieldKey, .string, .required)
            .field(UsersDbField.password.fieldKey, .string, .required)
            .field(UsersDbField.imageUrl.fieldKey, .string)
            .unique(on: UsersDbField.email.fieldKey)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
