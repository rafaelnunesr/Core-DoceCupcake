protocol PackagesControllerFactoryProtocol {
    func makePackagesController() throws -> PackagingController
}

final class PackagesControllerFactory: PackagesControllerFactoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
    }

    func makePackagesController() throws -> PackagingController {
        let database = dependencyProvider.getDatabaseInstance()
        let repository = Repository(database: database)
        return PackagingController(dependencyProvider: dependencyProvider, repository: repository)
    }
}
