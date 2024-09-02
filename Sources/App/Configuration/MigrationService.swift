protocol MigrationServiceProtocol {
    func addMigrations()
}

final class MigrationService: MigrationServiceProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let app: ApplicationProtocol
    
    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        app = dependencyProvider.getAppInstance()
    }
    
    func addMigrations() {
        addUserMigrations()
        addProductMigrations()
    }

    private func addUserMigrations() {
        app.migrations.add(CreateAdminMigration())
        app.migrations.add(CreateUsersMigration())
        app.migrations.add(CreateSessionMigration())
    }

    private func addProductMigrations() {
        app.migrations.add(CreateNutritionalInformationMigration())
        app.migrations.add(CreateProductTagMigration())
        app.migrations.add(CreateProductMigration())
        app.migrations.add(CreateVoucherMigration())
        app.migrations.add(CreateReviewMigration())
        app.migrations.add(CreateCardMigration())
    }
}
