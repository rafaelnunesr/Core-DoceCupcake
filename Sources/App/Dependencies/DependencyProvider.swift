import Fluent
import FluentPostgresDriver
import Vapor

protocol DependencyProviderProtocol {
    func getDatabaseInstance() -> Database
    func getAppInstance() -> ApplicationProtocol
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
}
