import Fluent
import FluentPostgresDriver
import Vapor

@testable import App

final class MockDependencyProvider: DependencyProviderProtocol {
    var app: Application
    var sectionController: SectionControllerProtocol
    var security: SecurityProtocol
    var adminValidationMiddleware: MockAdminValidationMiddleware

    init(app: Application,
         sectionController: SectionControllerProtocol = MockSectionController(),
         security: SecurityProtocol = MockSecurity(),
         adminValidationMiddleware: MockAdminValidationMiddleware = MockAdminValidationMiddleware()) {
        self.app = app
        self.sectionController = sectionController
        self.security = security
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
    
    func getUserSectionValidationMiddleware() -> SectionValidationMiddlewareProtocol {
        fatalError()
    }
    
    func getAdminSectionValidationMiddleware() -> AdminValidationMiddlewareProtocol {
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
    
    func getSectionController() -> SectionControllerProtocol {
        sectionController
    }
}