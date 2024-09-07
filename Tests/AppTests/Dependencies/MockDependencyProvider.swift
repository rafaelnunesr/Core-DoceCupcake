import Fluent
import FluentPostgresDriver
import Vapor

@testable import App

final class MockDependencyProvider: DependencyProviderProtocol {
    private let app: Application
    private let sectionController: SectionControllerProtocol
    private let security: SecurityProtocol

    init(app: Application,
         sectionController: SectionControllerProtocol = MockSectionController(),
         security: SecurityProtocol = MockSecurity()) {
        self.app = app
        self.sectionController = sectionController
        self.security = security
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
        fatalError()
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
