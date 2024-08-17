import Fluent
import FluentPostgresDriver
import Vapor

final class DependencyProvider: DependencyProviderProtocol {

    @MainActor
    static let shared = DependencyProvider()

    private init() {}

    // MARK: - DATABASE

    func getDatabaseInstance() -> DatabaseProtocol? {
        nil //MySQLDriver()
    }

    func setupDatabase(app: Application) {
        app.databases.use(
            .postgres(
                configuration: .init(
                    hostname: "localhost",
                    username: "rafaelrios",
                    password: "vapor",
                    database: "docecupcakedb",
                    tls: .disable
                )
            ),
            as: .psql
        )

        addMigrations(app: app)
    }

    private func addMigrations(app: Application) {
        app.migrations.add(CreateUsersDatabase())
        app.migrations.add(CreateSectionDatabase())
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
