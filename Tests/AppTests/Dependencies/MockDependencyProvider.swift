import Fluent
import FluentPostgresDriver
import Vapor

@testable import App

final class MockDependencyProvider: DependencyProviderProtocol {
    var app: Application
    var sectionController: SessionControllerProtocol
    var security: SecurityProtocol
    var sectionValidationMiddleware: MockSectionValidationMiddleware
    var adminValidationMiddleware: MockAdminValidationMiddleware

    init(app: Application,
         sectionController: SessionControllerProtocol = MockSectionController(),
         security: SecurityProtocol = MockSecurity(),
         sectionValidationMiddleware: MockSectionValidationMiddleware = MockSectionValidationMiddleware(),
         adminValidationMiddleware: MockAdminValidationMiddleware = MockAdminValidationMiddleware()) {
        self.app = app
        self.sectionController = sectionController
        self.security = security
        self.sectionValidationMiddleware = sectionValidationMiddleware
        self.adminValidationMiddleware = adminValidationMiddleware
    }

    func getDatabaseInstance() -> any Database {
        app.db
    }

    func getAppInstance() -> Application {
        app
    }
    
    func getSecurityInstance() -> any SecurityProtocol {
        security
    }
    
    func getUserSessionValidationMiddleware() -> SessionValidationMiddlewareProtocol {
        sectionValidationMiddleware
    }
    
    func getAdminSessionValidationMiddleware() -> AdminValidationMiddlewareProtocol {
        adminValidationMiddleware
    }
    
    func getMigrationServiceInstance() -> MigrationServiceProtocol {
        fatalError()
    }
    
    func getControllerFactory() -> ControllerFactoryProtocol {
        fatalError()
    }
    
    func getConfigurationServiceInstance() -> ConfigurationServiceProtocol {
        fatalError()
    }
    
    func getSectionController() -> SessionControllerProtocol {
        sectionController
    }
}
