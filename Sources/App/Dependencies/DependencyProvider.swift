import Fluent
import FluentPostgresDriver
import Vapor

protocol DependencyProviderProtocol {
    func getDatabaseInstance() -> Database
    func getAppInstance() -> ApplicationProtocol
    func getSecurityInstance() -> SecurityProtocol
    func getUserSectionValidationMiddleware() -> SectionValidationMiddlewareProtocol
    func getAdminSectionValidationMiddleware() -> AdminValidationMiddlewareProtocol
    func getMigrationServiceInstance() -> MigrationServiceProtocol
    func getControllerFactory() -> ControllerFactoryProtocol
    func getConfigurationServiceInstance() -> ConfigurationServiceProtocol
}

final class DependencyProvider: DependencyProviderProtocol {
    private let app: ApplicationProtocol

    init(app: ApplicationProtocol) {
        self.app = app
    }

    func getDatabaseInstance() -> any Database {
        app.db
    }

    func getAppInstance() -> ApplicationProtocol {
        app
    }
    
    func getSecurityInstance() -> any SecurityProtocol {
        Security()
    }
    
    func getUserSectionValidationMiddleware() -> SectionValidationMiddlewareProtocol {
        let sectionRepository = SectionRepository(dependencyProvider: self)
        let sectionControl = SectionController(dependencyProvider: self, repository: sectionRepository)
        return SectionValidationMiddleware(sectionController: sectionControl)
    }
    
    func getAdminSectionValidationMiddleware() -> AdminValidationMiddlewareProtocol {
        let sectionRepository = SectionRepository(dependencyProvider: self)
        let sectionControl = SectionController(dependencyProvider: self, repository: sectionRepository)
        return AdminValidationMiddleware(sectionController: sectionControl)
    }
    
    func getMigrationServiceInstance() -> MigrationServiceProtocol {
        let userMigrationService = UserMigrationService(app: app)
        let productMigrationService = ProductMigrationService(app: app)
        return MigrationService(userMigrationService: userMigrationService,
                                productMigrationService: productMigrationService)
    }
    
    func getControllerFactory() -> ControllerFactoryProtocol {
        let userController = UserControllerFactory(dependencyProvider: self)
        let productController = ProductControllerFactory(dependencyProvider: self)
        let voucherController = VoucherControllerFactory(dependencyProvider: self)
        return ControllerFactory(userControllerFactory: userController,
                                 productControllerFactory: productController,
                                 voucherControllerFactory: voucherController)
    }
    
    func getConfigurationServiceInstance() -> ConfigurationServiceProtocol {
        ConfigurationService(app: app)
    }
}
