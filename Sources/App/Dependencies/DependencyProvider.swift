import Fluent
import FluentPostgresDriver
import Vapor

protocol DependencyProviderProtocol {
    func getDatabaseInstance() -> Database
    func getAppInstance() -> ApplicationProtocol
    func getSecurityInstance() -> SecurityProtocol
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
}
