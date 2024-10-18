protocol MigrationServiceProtocol {
    func addMigrations()
}

final class MigrationService: MigrationServiceProtocol {
    private let userMigrationService: MigrationServiceProtocol
    private let productMigrationService: MigrationServiceProtocol
    private let ordersMigrationService: MigrationServiceProtocol
    private let reviewMigrationService: MigrationServiceProtocol
    
    init(userMigrationService: MigrationServiceProtocol,
         productMigrationService: MigrationServiceProtocol,
         ordersMigrationService: MigrationServiceProtocol,
         reviewMigrationService: MigrationServiceProtocol) {
        self.userMigrationService = userMigrationService
        self.productMigrationService = productMigrationService
        self.ordersMigrationService = ordersMigrationService
        self.reviewMigrationService = reviewMigrationService
    }
    
    func addMigrations() {
        userMigrationService.addMigrations()
        productMigrationService.addMigrations()
        ordersMigrationService.addMigrations()
        reviewMigrationService.addMigrations()
    }
}
