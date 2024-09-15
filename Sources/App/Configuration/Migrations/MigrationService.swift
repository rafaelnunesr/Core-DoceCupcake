protocol MigrationServiceProtocol {
    func addMigrations()
}

final class MigrationService: MigrationServiceProtocol {
    private let userMigrationService: MigrationServiceProtocol
    private let productMigrationService: MigrationServiceProtocol
    private let ordersMigrationService: MigrationServiceProtocol
    
    init(userMigrationService: MigrationServiceProtocol,
         productMigrationService: MigrationServiceProtocol,
         ordersMigrationService: MigrationServiceProtocol) {
        self.userMigrationService = userMigrationService
        self.productMigrationService = productMigrationService
        self.ordersMigrationService = ordersMigrationService
    }
    
    func addMigrations() {
        userMigrationService.addMigrations()
        productMigrationService.addMigrations()
        ordersMigrationService.addMigrations()
    }
}
