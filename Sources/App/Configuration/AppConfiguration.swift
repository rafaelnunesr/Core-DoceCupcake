import JWT
import Vapor

protocol AppConfigurationProtocol {
    func initialSetup() async throws
}

final class AppConfiguration: AppConfigurationProtocol {
    private let app: ApplicationProtocol
    private let migrationService: MigrationServiceProtocol
//    private let controllerFactory: ControllerFactoryProtocol
    private let configService: ConfigurationServiceProtocol
    
    init(dependencyProvider: DependencyProviderProtocol) {
        app = dependencyProvider.getAppInstance()
        
        migrationService = dependencyProvider.getMigrationServiceInstance()
//        controllerFactory = dependencyProvider.getControllerFactory()
       configService = dependencyProvider.getConfigurationServiceInstance()
    }

    func initialSetup() async throws {
        await configService.configureJwtSegurityKey()
        configService.setupDatabase()
        migrationService.addMigrations()
        
        do {
            try registerControllers()
        } catch {
            app.logger.report(error: error)
            try? await app.asyncShutdown()
            throw error
        }
    }
    
    private func registerControllers() throws {
//        let controllers = try controllerFactory.makeControllers()
//        for controller in controllers {
//            try app.register(collection: controller)
//        }
    }
}
