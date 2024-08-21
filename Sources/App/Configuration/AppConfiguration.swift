import Vapor

protocol AppConfigurationProtocol {
    func initialSetup() async throws
}

final class AppConfiguration: AppConfigurationProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let app: ApplicationProtocol

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        self.app = dependencyProvider.getAppInstance()
    }

    func initialSetup() async throws {
        setupDatabase()
        
        do {
            try self.registerControllers()
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
        app.migrations.add(CreateUsersDatabase())
        app.migrations.add(CreateSectionDatabase())
        app.migrations.add(CreateProductTagDatabase())
        //app.migrations.add(CreateProductDatabase())
    }

    private func registerControllers() throws {
        try registerSignInController()
        try registerSignUpController()
        try registerProductTagsController()
        //try registerProductController()
    }

    private func registerSignInController() throws {
        let respository = SignInRepository(dependencyProvider: dependencyProvider)
        let controller = SignInController(dependencyProvider: dependencyProvider, repository: respository)
        try app.register(collection: controller)
    }

    private func registerSignUpController() throws {
        let repository = SignUpRepository(dependencyProvider: dependencyProvider)
        try app.register(collection: SignUpController(dependencyProvider: dependencyProvider,
                                                      repository: repository))
    }

    private func registerProductController() throws {
        let repository = ProductRepository(dependencyProvider: dependencyProvider)
        try app.register(collection: ProductController(dependencyProvider: dependencyProvider,
                                                       repository: repository))
    }

    private func registerProductTagsController() throws {
        let repository = ProductTagsRepository(dependencyProvider: dependencyProvider)
        try app.register(collection: ProductTagsController(dependencyProvider: dependencyProvider,
                                                           repository: repository))
    }

    enum Constants {
        static let dbHostname = "localhost"
        static let dbUserName = "rafaelrios"
        static let dbPassword = "vapor"
        static let dbName = "docecupcakedb"
    }
}
