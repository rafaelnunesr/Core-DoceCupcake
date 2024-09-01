import Fluent
import FluentPostgresDriver
import Vapor

protocol DependencyProviderProtocol {
    func getDatabaseInstance() -> Database
    func getAppInstance() -> ApplicationProtocol
    func getSecurityInstance() -> SecurityProtocol
    func getUserSectionValidationMiddleware() -> SectionValidationMiddlewareProtocol
    func getAdminSectionValidationMiddleware() -> AdminValidationMiddlewareProtocol
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
}
