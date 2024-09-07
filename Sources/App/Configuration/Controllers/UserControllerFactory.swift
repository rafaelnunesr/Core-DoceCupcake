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
        let repository = SignInRepository(dependencyProvider: dependencyProvider)
        return SignInController(dependencyProvider: dependencyProvider, repository: repository)
    }

    func makeUserSignUpController() throws -> SignUpUserController {
        let repository = SignUpUserRepository(dependencyProvider: dependencyProvider)
        return SignUpUserController(dependencyProvider: dependencyProvider, repository: repository)
    }

    func makeAdminSignUpController() throws -> SignUpAdminController {
        let repository = SignUpAdminRepository(dependencyProvider: dependencyProvider)
        return SignUpAdminController(dependencyProvider: dependencyProvider, repository: repository)
    }
}
