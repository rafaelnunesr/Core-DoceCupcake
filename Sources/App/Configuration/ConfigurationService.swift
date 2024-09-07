import Vapor

protocol ConfigurationServiceProtocol {
    func configureJwtSegurityKey() async
    func setupDatabase()
}

final class ConfigurationService: ConfigurationServiceProtocol {
    private var app: Application
    
    init(app: Application) {
        self.app = app
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
