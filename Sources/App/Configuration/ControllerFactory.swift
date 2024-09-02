import Vapor

protocol ControllerFactoryProtocol {
    func makeControllers() throws -> [RouteCollection]
}

final class ControllerFactory: ControllerFactoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
    }

    func makeControllers() throws -> [RouteCollection] {
        return [
            try makeSignInController(),
            try makeUserSignUpController(),
            try makeAdminSignUpController(),
            try makeProductController(),
            try makeProductTagsController(),
            try makeProductReviewController(),
            try makeVoucherController()
        ]
    }

    private func makeSignInController() throws -> SignInController {
        let repository = SignInRepository(dependencyProvider: dependencyProvider)
        let sectionRepository = SectionRepository(dependencyProvider: dependencyProvider)
        let sectionController = SectionController(dependencyProvider: dependencyProvider, repository: sectionRepository)
        return SignInController(dependencyProvider: dependencyProvider, repository: repository, sectionController: sectionController)
    }

    private func makeUserSignUpController() throws -> SignUpUserController {
        let repository = SignUpUserRepository(dependencyProvider: dependencyProvider)
        return SignUpUserController(dependencyProvider: dependencyProvider, repository: repository)
    }

    private func makeAdminSignUpController() throws -> SignUpAdminController {
        let repository = SignUpManagerRepository(dependencyProvider: dependencyProvider)
        return SignUpAdminController(dependencyProvider: dependencyProvider, repository: repository)
    }

    private func makeProductController() throws -> ProductController {
        let productRepository = ProductRepository(dependencyProvider: dependencyProvider)
        let nutritionalRepository = NutritionalRepository(dependencyProvider: dependencyProvider)
        let tagRepository = Repository(dependencyProvider: dependencyProvider)
        let tagController = ProductTagsController(dependencyProvider: dependencyProvider, repository: tagRepository)
        let nutritionalController = NutritionalController(dependencyProvider: dependencyProvider, repository: nutritionalRepository)
        return ProductController(dependencyProvider: dependencyProvider, productRepository: productRepository, tagsController: tagController, nutritionalController: nutritionalController)
    }

    private func makeProductTagsController() throws -> ProductTagsController {
        let repository = Repository(dependencyProvider: dependencyProvider)
        return ProductTagsController(dependencyProvider: dependencyProvider, repository: repository)
    }

    private func makeProductReviewController() throws -> ReviewController {
        let productRepository = ProductRepository(dependencyProvider: dependencyProvider)
        let reviewRepository = ReviewRepository(dependencyProvider: dependencyProvider)
        return ReviewController(dependencyProvider: dependencyProvider, productRepository: productRepository, reviewRepository: reviewRepository)
    }

    private func makeVoucherController() throws -> VouchersController {
        let repository = Repository(dependencyProvider: dependencyProvider)
        return VouchersController(dependencyProvider: dependencyProvider, repository: repository)
    }
}
