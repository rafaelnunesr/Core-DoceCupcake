import Fluent

protocol ProductControllerFactoryProtocol {
    func makeProductController() throws -> ProductController
    func makeProductTagsController() throws -> ProductTagsController
    func makeProductReviewController() throws -> ReviewController
}

struct ProductControllerFactory: ProductControllerFactoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
    }

    func makeProductController() throws -> ProductController {
        let database = dependencyProvider.getDatabaseInstance()
        let productRepository = ProductRepository(database: database)
        let nutritionalRepository = NutritionalRepository(database: database)
        let tagRepository = Repository(database: database)
        let tagController = ProductTagsController(dependencyProvider: dependencyProvider,
                                                  repository: tagRepository)
        let nutritionalController = NutritionalController(repository: nutritionalRepository)
        return ProductController(dependencyProvider: dependencyProvider,
                                 productRepository: productRepository,
                                 tagsController: tagController,
                                 nutritionalController: nutritionalController)
    }

    func makeProductTagsController() throws -> ProductTagsController {
        let database = dependencyProvider.getDatabaseInstance()
        let repository = Repository(database: database)
        return ProductTagsController(dependencyProvider: dependencyProvider, repository: repository)
    }

    func makeProductReviewController() throws -> ReviewController {
        let database = dependencyProvider.getDatabaseInstance()
        let productRepository = ProductRepository(database: database)
        let reviewRepository = ReviewRepository(dependencyProvider: dependencyProvider)
        
        let sessionRepository = SessionRepository(database: database)
        let sessionController = SessionController(repository: sessionRepository)
        
        return ReviewController(dependencyProvider: dependencyProvider,
                                productRepository: productRepository,
                                reviewRepository: reviewRepository,
                                sessionController: sessionController,
                                orderController: makeOrderController())
    }
    
    func makeOrderController() -> OrderController {
        let database = dependencyProvider.getDatabaseInstance()
        let orderRepository = OrderRepository(database: database)
        let orderItemRepository = OrderItemRepository(database: database)
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
        let sessionController = createSessionController()
        let sessionValidation = dependencyProvider.getUserSessionValidationMiddleware()
        return AddressController(repository: addressRepository,
                                 sessionValidation: sessionValidation,
                                 sessionController: sessionController)
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
