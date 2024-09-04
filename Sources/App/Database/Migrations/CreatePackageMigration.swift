//import Fluent
//
//struct CreatePackageMigration: AsyncMigration {
//    private let databaseName = PackageDbField.schema.rawValue
//
//    func prepare(on database: Database) async throws {
//        try await database.schema(databaseName)
//            .id()
//            .field(PackageDbField.createdAt.fieldKey, .datetime)
//            .field(PackageDbField.code.fieldKey, .string, .required)
//            .field(PackageDbField.name.fieldKey, .string, .required)
//            .field(PackageDbField.description.fieldKey, .string, .required)
//            .field(PackageDbField.width.fieldKey, .double, .required)
//            .field(PackageDbField.height.fieldKey, .double, .required)
//            .field(PackageDbField.depth.fieldKey, .double, .required)
//            .field(PackageDbField.price.fieldKey, .double, .required)
//            .field(PackageDbField.stockCount.fieldKey, .int, .required)
//            .unique(on: PackageDbField.code.fieldKey)
//            .create()
//    }
//
//    func revert(on database: Database) async throws {
//        try await database.schema(databaseName).delete()
//    }
//}
