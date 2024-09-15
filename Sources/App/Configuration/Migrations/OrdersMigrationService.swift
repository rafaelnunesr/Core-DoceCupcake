import Vapor

final class OrdersMigrationService: MigrationServiceProtocol {
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }
    
    func addMigrations() {
        app.migrations.add(CreateOrderMigration())
        app.migrations.add(CreateOrderItemMigration())
    }
}
