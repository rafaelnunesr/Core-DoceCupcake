final class ProductMigrationService: MigrationServiceProtocol {
    private let app: ApplicationProtocol
    
    init(app: ApplicationProtocol) {
        self.app = app
    }
    
    func addMigrations() {
        app.migrations.add(CreateNutritionalInformationMigration())
        app.migrations.add(CreateProductTagMigration())
        app.migrations.add(CreateProductMigration())
        app.migrations.add(CreateVoucherMigration())
        app.migrations.add(CreateReviewMigration())
        app.migrations.add(CreateCreditCardMigration())
    }
}
