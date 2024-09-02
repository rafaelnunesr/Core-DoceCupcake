protocol MigrationServiceProtocol {
    func addMigrations()
}

final class MigrationService: MigrationServiceProtocol {
    private let userMigrationService: MigrationServiceProtocol
    private let productMigrationService: MigrationServiceProtocol
    
    init(userMigrationService: MigrationServiceProtocol,
         productMigrationService: MigrationServiceProtocol) {
        self.userMigrationService = userMigrationService
        self.productMigrationService = productMigrationService
    }
    
    func addMigrations() {
        userMigrationService.addMigrations()
        productMigrationService.addMigrations()
    }
}
