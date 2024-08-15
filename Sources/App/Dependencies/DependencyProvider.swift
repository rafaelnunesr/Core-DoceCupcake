import Fluent
import FluentMySQLDriver
import Vapor

final class DependencyProvider: DependencyProviderProtocol {

    @MainActor
    static let shared = DependencyProvider()

    @MainActor
    static var app: Application?

    private init() {}

    // MARK: - DATABASE

    func getDatabaseInstance() -> DatabaseProtocol? {
        nil //MySQLDriver()
    }

    @MainActor 
    private func setupDatabase() {
        guard let app = DependencyProvider.app else { return }

        // Allow connection without SSL certificate involved
        // That's suitable for local connection and should not be done in production
        var tls = TLSConfiguration.makeClientConfiguration()
        tls.certificateVerification = .none

        app.databases.use(
            .mysql(hostname: Constants.dbHostname,
                   username: Constants.dbUserName,
                   password: Constants.dbPassword,
                   database: Constants.dbName,
                   tlsConfiguration: tls),
            as: .mysql
        )
    }

    // MARK: - SECTIONTOKEN

    func getSectionTokenGeneratorInstance() -> SectionTokenGeneratorProtocol {
        SectionTokenGenerator()
    }

    enum Constants {
        static let dbHostname = "localhost"
        static let dbUserName = "vapor"
        static let dbPassword = "vapor"
        static let dbName = "vapor"
    }
}
