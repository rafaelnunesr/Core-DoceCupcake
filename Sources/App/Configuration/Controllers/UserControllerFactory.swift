protocol UserControllerFactoryProtocol {
    func makeSignInController() throws -> SignInController
    func makeUserSignUpController() throws -> SignUpUserController
    func makeAdminSignUpController() throws -> SignUpAdminController
    func makeSessionController() throws -> SessionController
    func makeAddressController() throws -> AddressController
}

struct UserControllerFactory: UserControllerFactoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
    }

    func makeSignInController() throws -> SignInController {
        let repository = SignInRepository(database: dependencyProvider.getDatabaseInstance())
        return SignInController(dependencyProvider: dependencyProvider, repository: repository)
    }

    func makeUserSignUpController() throws -> SignUpUserController {
        let database = dependencyProvider.getDatabaseInstance()
        let repository = SignUpUserRepository(database: database)
        let sessionRepository = SessionRepository(database: database)
        let sessionController = SessionController(repository: sessionRepository)
        let addressRepository = AddressRepository(database: database)
        let addressController = AddressController(repository: addressRepository,
                                                  sessionValidation: dependencyProvider.getUserSessionValidationMiddleware(),
                                                  sessionController: sessionController)
        return SignUpUserController(dependencyProvider: dependencyProvider,
                                    repository: repository,
                                    addressController: addressController)
    }

    func makeAdminSignUpController() throws -> SignUpAdminController {
        let repository = SignUpAdminRepository(database: dependencyProvider.getDatabaseInstance())
        return SignUpAdminController(dependencyProvider: dependencyProvider, repository: repository)
    }
    
    func makeSessionController() throws -> SessionController {
        let repository = SessionRepository(database: dependencyProvider.getDatabaseInstance())
        return SessionController(repository: repository)
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
