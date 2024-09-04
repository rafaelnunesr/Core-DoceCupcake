final class UserMigrationService: MigrationServiceProtocol {
    private let app: ApplicationProtocol
    
    init(app: ApplicationProtocol) {
        self.app = app
    }
    
    func addMigrations() {
        //app.migrations.add(CreateAdminMigration())
        //app.migrations.add(CreateUsersMigration())
        //app.migrations.add(CreateAddressMigration())
        //app.migrations.add(CreateSessionMigration())
    }
}
