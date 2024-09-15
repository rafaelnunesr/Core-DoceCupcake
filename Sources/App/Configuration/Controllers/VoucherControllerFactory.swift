protocol VoucherControllerFactoryProtocol {
    func makeVoucherController() throws -> VouchersController
}

final class VoucherControllerFactory: VoucherControllerFactoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
    }

    func makeVoucherController() throws -> VouchersController {
        let database = dependencyProvider.getDatabaseInstance()
        let repository = Repository(database: database)
        return VouchersController(dependencyProvider: dependencyProvider, repository: repository)
    }
}
