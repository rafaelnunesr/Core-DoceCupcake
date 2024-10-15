protocol AddressControllerFactoryProtocol {
    func makeAddressController() throws -> AddressController
}

final class AddressControllerFactory: AddressControllerFactoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
    }

    func makeAddressController() throws -> AddressController {
        let database = dependencyProvider.getDatabaseInstance()
        let repository = AddressRepository(database: database)
        let sessionValidation = dependencyProvider.getUserSessionValidationMiddleware()
        let sessionRepository = SessionRepository(database: database)
        let sessionController = SessionController(repository: sessionRepository)
        return AddressController(repository: repository,
                                 sessionValidation: sessionValidation,
                                 sessionController: sessionController)
    }
}
