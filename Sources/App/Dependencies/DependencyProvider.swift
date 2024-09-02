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
    func getUserControllerFactory() -> UserControllerFactoryProtocol
    func getProductControllerFactory() -> ProductControllerFactoryProtocol
    func getVoucherControllerFactory() -> VoucherControllerFactoryProtocol
    func getUserMigrationServiceInstance() -> MigrationServiceProtocol
    func getProdductMigrationServiceInstance() -> MigrationServiceProtocol
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
        MigrationService(dependencyProvider: self)
    }
    
    func getControllerFactory() -> ControllerFactoryProtocol {
        ControllerFactory(dependencyProvider: self)
    }
    
    func getConfigurationServiceInstance() -> ConfigurationServiceProtocol {
        ConfigurationService(app: app)
    }
    
    func getUserControllerFactory() -> UserControllerFactoryProtocol {
        UserControllerFactory(dependencyProvider: self)
    }
    
    func getProductControllerFactory() -> ProductControllerFactoryProtocol {
        ProductControllerFactory(dependencyProvider: self)
    }
    
    func getVoucherControllerFactory() -> VoucherControllerFactoryProtocol {
        VoucherControllerFactory(dependencyProvider: self)
    }
    
    func getUserMigrationServiceInstance() -> MigrationServiceProtocol {
        UserMigrationService(app: app)
    }
    
    func getProdductMigrationServiceInstance() -> MigrationServiceProtocol {
        ProductMigrationService(app: app)
    }
}
