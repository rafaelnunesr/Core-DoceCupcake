import Fluent
import FluentPostgresDriver
import Vapor

protocol DependencyProviderProtocol: Sendable {
    func getDatabaseInstance() -> Database
    func getAppInstance() -> Application
    func getSecurityInstance() -> SecurityProtocol
    func getUserSessionValidationMiddleware() -> SessionValidationMiddlewareProtocol
    func getAdminSessionValidationMiddleware() -> AdminValidationMiddlewareProtocol
    func getMigrationServiceInstance() -> MigrationServiceProtocol
    func getControllerFactory() -> ControllerFactoryProtocol
    func getConfigurationServiceInstance() -> ConfigurationServiceProtocol
    func getSessionController() -> SessionControllerProtocol
}

final class DependencyProvider: DependencyProviderProtocol {
    private let app: Application

    init(app: Application) {
        self.app = app
    }

    func getDatabaseInstance() -> any Database {
        app.db
    }

    func getAppInstance() -> Application {
        app
    }
    
    func getSecurityInstance() -> any SecurityProtocol {
        Security()
    }
    
    func getUserSessionValidationMiddleware() -> SessionValidationMiddlewareProtocol {
        let sessionRepository = SessionRepository(database: getDatabaseInstance())
        let sessionControl = SessionController(repository: sessionRepository)
        return SessionValidationMiddleware(sessionController: sessionControl)
    }
    
    func getAdminSessionValidationMiddleware() -> AdminValidationMiddlewareProtocol {
        let sessionRepository = SessionRepository(database: getDatabaseInstance())
        let sessionControl = SessionController(repository: sessionRepository)
        return AdminValidationMiddleware(sessionController: sessionControl)
    }
    
    func getMigrationServiceInstance() -> MigrationServiceProtocol {
        let userMigrationService = UserMigrationService(app: app)
        let productMigrationService = ProductMigrationService(app: app)
        let ordersMigrationService = OrdersMigrationService(app: app)
        return MigrationService(userMigrationService: userMigrationService,
                                productMigrationService: productMigrationService,
                                ordersMigrationService: ordersMigrationService)
    }
    
    func getControllerFactory() -> ControllerFactoryProtocol {
        let userController = UserControllerFactory(dependencyProvider: self)
        let productController = ProductControllerFactory(dependencyProvider: self)
        let voucherController = VoucherControllerFactory(dependencyProvider: self)
        let ordersController = OrdersControllerFactory(dependencyProvider: self)
        return ControllerFactory(userControllerFactory: userController,
                                 productControllerFactory: productController,
                                 voucherControllerFactory: voucherController,
                                 ordersControllerFactory: ordersController)
    }
    
    func getConfigurationServiceInstance() -> ConfigurationServiceProtocol {
        ConfigurationService(app: app)
    }
    
    func getSessionController() -> SessionControllerProtocol {
        let repository = SessionRepository(database: getDatabaseInstance())
        return SessionController(repository: repository)
    }
}
