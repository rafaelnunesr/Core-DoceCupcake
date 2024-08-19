import Fluent
import FluentPostgresDriver
import Vapor

final class DependencyProvider: DependencyProviderProtocol {
    private let app: Application

    init(app: Application) {
        self.app = app
    }

    // MARK: - SECTIONTOKEN

    func getSectionTokenGeneratorInstance() -> SectionTokenGeneratorProtocol {
        SectionTokenGenerator()
    }
}
