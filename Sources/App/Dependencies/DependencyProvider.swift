import Fluent
import FluentPostgresDriver
import Vapor

protocol DependencyProviderProtocol {
    func getSectionTokenGeneratorInstance() -> SectionTokenGeneratorProtocol
    func getDatabaseInstance() -> Database
    func getAppInstance() -> ApplicationProtocol
}


final class DependencyProvider: DependencyProviderProtocol {
    private let app: ApplicationProtocol

    init(app: ApplicationProtocol) {
        self.app = app
    }

    // MARK: - SECTIONTOKEN

    func getSectionTokenGeneratorInstance() -> SectionTokenGeneratorProtocol {
        SectionTokenGenerator()
    }

    func getDatabaseInstance() -> any Database {
        app.db
    }

    func getAppInstance() -> ApplicationProtocol {
        app
    }
}
