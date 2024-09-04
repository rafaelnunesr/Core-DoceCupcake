protocol ProductControllerFactoryProtocol {
//    func makeProductController() throws -> ProductController
//    func makeProductTagsController() throws -> ProductTagsController
//    func makeProductReviewController() throws -> ReviewController
}

final class ProductControllerFactory: ProductControllerFactoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
    }

//    func makeProductController() throws -> ProductController {
//        let productRepository = ProductRepository(dependencyProvider: dependencyProvider)
//        let nutritionalRepository = NutritionalRepository(dependencyProvider: dependencyProvider)
//        let tagRepository = Repository(dependencyProvider: dependencyProvider)
//        let tagController = ProductTagsController(dependencyProvider: dependencyProvider, repository: tagRepository)
//        let nutritionalController = NutritionalController(dependencyProvider: dependencyProvider, repository: nutritionalRepository)
//        return ProductController(dependencyProvider: dependencyProvider, productRepository: productRepository, tagsController: tagController, nutritionalController: nutritionalController)
//    }
//
//    func makeProductTagsController() throws -> ProductTagsController {
//        let repository = Repository(dependencyProvider: dependencyProvider)
//        return ProductTagsController(dependencyProvider: dependencyProvider, repository: repository)
//    }
//
//    func makeProductReviewController() throws -> ReviewController {
//        let productRepository = ProductRepository(dependencyProvider: dependencyProvider)
//        let reviewRepository = ReviewRepository(dependencyProvider: dependencyProvider)
//        return ReviewController(dependencyProvider: dependencyProvider, productRepository: productRepository, reviewRepository: reviewRepository)
//    }
}
