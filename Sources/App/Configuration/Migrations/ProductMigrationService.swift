import Vapor

final class ProductMigrationService: MigrationServiceProtocol {
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }
    
    func addMigrations() {
        app.migrations.add(CreateNutritionalInformationMigration())
        app.migrations.add(CreateProductTagMigration())
        app.migrations.add(CreateVoucherMigration())
        app.migrations.add(CreateProductMigration())
        app.migrations.add(CreateCreditCardMigration())
        app.migrations.add(CreatePackageMigration())
    }
}
