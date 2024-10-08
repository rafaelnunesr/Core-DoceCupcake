import Fluent
import FluentPostgresDriver
import Vapor

@testable import App

final class MockDependencyProvider: DependencyProviderProtocol {
    var app: Application
    var sessionController: SessionControllerProtocol
    var security: SecurityProtocol
    var sessionValidationMiddleware: MockSessionValidationMiddleware
    var adminValidationMiddleware: MockAdminValidationMiddleware

    init(app: Application,
         sessionController: SessionControllerProtocol = MockSessionController(),
         security: SecurityProtocol = MockSecurity(),
         sessionValidationMiddleware: MockSessionValidationMiddleware = MockSessionValidationMiddleware(),
         adminValidationMiddleware: MockAdminValidationMiddleware = MockAdminValidationMiddleware()) {
        self.app = app
        self.sessionController = sessionController
        self.security = security
        self.sessionValidationMiddleware = sessionValidationMiddleware
        self.adminValidationMiddleware = adminValidationMiddleware
        
        app.databases.use(.postgres(configuration: .init(hostname: .empty, username: .empty, tls: .disable)), as: .psql)
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
        sessionValidationMiddleware
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
    
    func getSessionController() -> SessionControllerProtocol {
        sessionController
    }
}
