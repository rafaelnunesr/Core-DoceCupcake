protocol UserControllerFactoryProtocol {
    func makeSignInController() throws -> SignInController
    func makeUserSignUpController() throws -> SignUpUserController
    func makeAdminSignUpController() throws -> SignUpAdminController
}

final class UserControllerFactory: UserControllerFactoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
    }

    func makeSignInController() throws -> SignInController {
        let repository = SignInRepository(database: dependencyProvider.getDatabaseInstance())
        return SignInController(dependencyProvider: dependencyProvider, repository: repository)
    }

    func makeUserSignUpController() throws -> SignUpUserController {
        let repository = SignUpUserRepository(database: dependencyProvider.getDatabaseInstance())
        let addressRepository = AddressRepository(dependencyProvider: dependencyProvider)
        let addressController = AddressController(repository: addressRepository)
        return SignUpUserController(dependencyProvider: dependencyProvider,
                                    repository: repository,
                                    addressController: addressController)
    }

    func makeAdminSignUpController() throws -> SignUpAdminController {
        let repository = SignUpAdminRepository(database: dependencyProvider.getDatabaseInstance())
        return SignUpAdminController(dependencyProvider: dependencyProvider, repository: repository)
    }
}
