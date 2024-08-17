import Vapor
import Fluent
import FluentMySQLDriver

enum Databases: String {
    case section
}

struct CreateDatabases: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await createSectionDatabase(on: database)
    }

    func revert(on database: Database) async throws {
        try await deleteSectionDatabase(on: database)
    }

    private func createSectionDatabase(on database: Database) async throws {
        try await database.schema(Databases.section.rawValue)
            .id()
            .field("created_at", .string)
            .field("expiry_date", .string)
            .field("user_id", .string)
            .field("token", .string)
            .create()
    }

    private func deleteSectionDatabase(on database: Database) async throws {
        try await database.schema(Databases.section.rawValue).delete()
    }
}
