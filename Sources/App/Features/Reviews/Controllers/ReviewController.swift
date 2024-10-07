import FluentPostgresDriver
import Foundation
import Vapor

struct ReviewController: RouteCollection {
    private let dependencyProvider: DependencyProviderProtocol
    private let productRepository: ProductRepositoryProtocol
    private let reviewRepository: ReviewRepositoryProtocol
    private let sessionController: SessionControllerProtocol
    
    private let userSectionValidation: SessionValidationMiddlewareProtocol
    private let adminSectionValidation: AdminValidationMiddlewareProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         productRepository: ProductRepositoryProtocol,
         reviewRepository: ReviewRepositoryProtocol,
         sessionController: SessionControllerProtocol) {
        self.dependencyProvider = dependencyProvider
        self.productRepository = productRepository
        self.reviewRepository = reviewRepository
        self.sessionController = sessionController
        
        userSectionValidation = dependencyProvider.getUserSessionValidationMiddleware()
        adminSectionValidation = dependencyProvider.getAdminSessionValidationMiddleware()
    }

    func boot(routes: RoutesBuilder) throws {
        let reviewRoutes = routes.grouped(PathRoutes.review.path)
        
        reviewRoutes
            .grouped(userSectionValidation)
            .get(":productId", use: fetchList)
        
        reviewRoutes
            .grouped(userSectionValidation)
            .post(use: create)
        
        reviewRoutes
            .grouped(adminSectionValidation)
            .delete(use: delete)
    }

    @Sendable
    private func fetchList(req: Request) async throws -> APIReviewListResponse {
        let model: APIReview = try convertRequestDataToModel(req: req)
        let result = try await reviewRepository.getReviewList(productId: model.productId.uuid)

        let reviews = result.map { ReviewResponse(from: $0) }
        return APIReviewListResponse(count: result.count, reviews: reviews)
    }

    @Sendable
    private func create(req: Request) async throws -> GenericMessageResponse {
        let model: APICreateReview = try convertRequestDataToModel(req: req)
        
        let userId = try await sessionController.fetchLoggedUserId(req: req)

        guard try await productRepository.fetchProduct(with: model.productId) != nil else {
            throw APIResponseError.Common.notFound
        }

        guard try await reviewRepository.getReview(orderId: model.orderId.uuid) == nil else {
            throw APIResponseError.Common.conflict
        }

        try await reviewRepository.createReview(Review(from: model, userId: userId))

        return GenericMessageResponse(message: Constants.reviewCreated)
    }

    @Sendable
    private func delete(req: Request) async throws -> GenericMessageResponse {
        let model: APIRequestId = try convertRequestDataToModel(req: req)

        guard let reviewModel = try await reviewRepository.getReview(orderId: model.id.uuid) else {
            throw APIResponseError.Common.notFound
        }

        try await reviewRepository.deleteReview(reviewModel)

        return GenericMessageResponse(message: Constants.reviewDeleted)
    }

    private enum Constants {
        static let reviewCreated = "Review created"
        static let reviewDeleted = "Review deleted"
    }
}

