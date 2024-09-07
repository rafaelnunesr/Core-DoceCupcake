import Vapor

final class UserMigrationService: MigrationServiceProtocol {
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }
    
    func addMigrations() {
        app.migrations.add(CreateAdminMigration())
        app.migrations.add(CreateUsersMigration())
        app.migrations.add(CreateAddressMigration())
        app.migrations.add(CreateSessionMigration())
    }
}
