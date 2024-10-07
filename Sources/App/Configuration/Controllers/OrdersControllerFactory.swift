import Fluent

protocol OrdersControllerFactoryProtocol {
    func makeOrderController() throws -> OrderController
}

struct OrdersControllerFactory: OrdersControllerFactoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
    }

    func makeOrderController() throws -> OrderController {
        let database = dependencyProvider.getDatabaseInstance()
        let orderRepository = OrderRepository(database: database)
        let orderItemRepository = OrderItemRepository(database: database)
        let sessionController = createSessionController()
        
        let addressController = createAddressController()
        let productController = createProductController()
        let cardController = createCardController()
        let vouchersController = createVouchersController()
        let deliveryController = createDeliveryController()
        
        return OrderController(dependencyProvider: dependencyProvider, 
                               orderRepository: orderRepository,
                               orderItemRepository: orderItemRepository,
                               addressController: addressController,
                               productController: productController,
                               cardController: cardController,
                               vouchersController: vouchersController, 
                               deliveryController: deliveryController)
        
    }
    
    private func createSessionController() -> SessionControllerProtocol {
        let database = dependencyProvider.getDatabaseInstance()
        let sessionRepository = SessionRepository(database: database)
        return SessionController(repository: sessionRepository)
    }
    
    private func createAddressController() -> AddressControllerProtocol {
        let database = dependencyProvider.getDatabaseInstance()
        let addressRepository = AddressRepository(database: database)
        return AddressController(repository: addressRepository)
    }
    
    private func createProductController() -> ProductControllerProtocol {
        let database = dependencyProvider.getDatabaseInstance()
        let productRepository = ProductRepository(database: database)
        let tagsRepository = Repository(database: database)
        let tagsController = ProductTagsController(dependencyProvider: dependencyProvider, repository: tagsRepository)
        let nutritionalRepository = NutritionalRepository(database: database)
        let nutritionalController = NutritionalController(repository: nutritionalRepository)
        return ProductController(dependencyProvider: dependencyProvider,
                                 productRepository: productRepository,
                                 tagsController: tagsController,
                                 nutritionalController: nutritionalController)
    }
    
    private func createCardController() -> CardControllerProtocol {
        let database = dependencyProvider.getDatabaseInstance()
        let cardRepository = CardRepository(database: database)
        return CardController(dependencyProvider: dependencyProvider, repository: cardRepository)
    }
    
    private func createVouchersController() -> VouchersControllerProtocol {
        let database = dependencyProvider.getDatabaseInstance()
        let vouchersRepository = Repository(database: database)
        return VouchersController(dependencyProvider: dependencyProvider, repository: vouchersRepository)
    }
    
    private func createDeliveryController() -> DeliveryControllerProtocol {
        return DeliveryController(userSectionValidation: dependencyProvider.getUserSessionValidationMiddleware())
    }
}
