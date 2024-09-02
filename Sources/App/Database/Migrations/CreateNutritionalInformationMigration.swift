import Foundation
import Fluent

struct CreateNutritionalInformationMigration: AsyncMigration {
    private let databaseName = NutritionalInformationDbField.schema.rawValue

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field(NutritionalInformationDbField.code.fieldKey, .string, .required)
            .field(NutritionalInformationDbField.name.fieldKey, .string, .required)
            .field(NutritionalInformationDbField.quantityDescription.fieldKey, .string, .required)
            .field(NutritionalInformationDbField.dailyRepresentation.fieldKey, .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
