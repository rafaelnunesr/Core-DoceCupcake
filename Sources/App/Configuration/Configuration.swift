import Vapor

protocol ConfigurationProtocol {
    func initialSetup() async throws
}

final class Configuration: ConfigurationProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let app: Application

    init(dependencyProvider: DependencyProviderProtocol? = nil, app: Application) {
        if let dependencyProvider {
            self.dependencyProvider = dependencyProvider
        } else {
            self.dependencyProvider = DependencyProvider(app: app)
        }

        self.app = app
    }

    func initialSetup() async throws {
        setupDatabase()
        
        do {
            try await self.registerControllers()
        } catch {
            app.logger.report(error: error)
            try? await app.asyncShutdown()
            throw error
        }
    }

    private func setupDatabase() {
        app.databases.use(
            .postgres(
                configuration: .init(
                    hostname: Constants.dbHostname,
                    username: Constants.dbUserName,
                    password: Constants.dbPassword,
                    database: Constants.dbName,
                    tls: .disable
                )
            ),
            as: .psql
        )

        addMigrations()
    }

    private func addMigrations() {
        app.migrations.add(CreateUserDatabase())
        app.migrations.add(CreateSectionDatabase())
    }

    private func registerControllers() async throws {
        try registerSignInController()
        try await registerSignUpController()
    }

    private func registerSignInController() throws {
        try app.register(collection: SignInController(dependencyProvider: dependencyProvider,
                                                      database: app.db))
    }

    private func registerSignUpController() async throws {
        try app.register(collection: SignUpController(database: app.db))
    }

    enum Constants {
        static let dbHostname = "localhost"
        static let dbUserName = "rafaelrios"
        static let dbPassword = "vapor"
        static let dbName = "docecupcakedb"
    }
}
