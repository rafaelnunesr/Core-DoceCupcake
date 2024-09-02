protocol MigrationServiceProtocol {
    func addMigrations()
}

final class MigrationService: MigrationServiceProtocol {
    private let userMigrationService: MigrationServiceProtocol
    private let productMigrationService: MigrationServiceProtocol
    
    init(dependencyProvider: DependencyProviderProtocol) {
        userMigrationService = dependencyProvider.getUserMigrationServiceInstance()
        productMigrationService = dependencyProvider.getProdductMigrationServiceInstance()
    }
    
    func addMigrations() {
        userMigrationService.addMigrations()
        productMigrationService.addMigrations()
    }
}
