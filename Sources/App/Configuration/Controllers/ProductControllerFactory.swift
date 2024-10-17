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
                                sessionController: sessionController)
    }
}
