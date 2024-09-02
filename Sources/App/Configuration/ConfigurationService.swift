import Vapor

protocol ConfigurationServiceProtocol {
    func configureJwtSegurityKey() async
    func setupDatabase()
}

final class ConfigurationService: ConfigurationServiceProtocol {
    private var app: ApplicationProtocol
    
    init(dependecyProvider: DependencyProviderProtocol) {
        app = dependecyProvider.getAppInstance()
    }

    func setupDatabase() {
        app.databases.use(
            .postgres(
                configuration: .init(
                    hostname: EnvironmentKeys.dbHostname,
                    username: EnvironmentKeys.dbUserName,
                    password: EnvironmentKeys.dbPassword,
                    database: EnvironmentKeys.dbName,
                    tls: .disable
                )
            ),
            as: .psql
        )
    }
    
    func configureJwtSegurityKey() async {
        await app.jwt.keys.add(hmac: "secret", digestAlgorithm: .sha256)
    }
}
