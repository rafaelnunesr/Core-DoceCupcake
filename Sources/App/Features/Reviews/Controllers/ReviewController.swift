import FluentPostgresDriver
import Foundation
import Vapor

struct ReviewController: RouteCollection {
    private let dependencyProvider: DependencyProviderProtocol
    private let productRepository: ProductRepositoryProtocol
    private let reviewRepository: ReviewRepositoryProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         productRepository: ProductRepositoryProtocol,
         reviewRepository: ReviewRepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.productRepository = productRepository
        self.reviewRepository = reviewRepository
    }

    func boot(routes: RoutesBuilder) throws {
        let productRoutes = routes.grouped("review")
        productRoutes.get(":productId", use: getReviewList)
        productRoutes.post(use: createReview)
        productRoutes.delete(use: deleteReview)
    }

    private func getReviewList(req: Request) async throws -> APIReviewListResponse {
        let model: APIReviewModel = try convertRequestDataToModel(req: req)
        let result = try await reviewRepository.getReviewList(productId: model.productId)

        let reviews = result.map { APIReviewResponse(from: $0) }
        return APIReviewListResponse(count: result.count, reviews: reviews)
    }

    private func createReview(req: Request) async throws -> APIGenericMessageResponse {
        let model: APICreateReviewModel = try convertRequestDataToModel(req: req)

        guard try await productRepository.getProduct(with: model.productId) != nil else {
            throw Abort(.notFound, reason: APIErrorMessage.Common.notFound)
        }

        guard try await reviewRepository.getReview(orderId: model.orderId) == nil else {
            throw Abort(.conflict, reason: APIErrorMessage.Common.conflict)
        }

        try await reviewRepository.createReview(InternalProductReview(from: model))

        return APIGenericMessageResponse(message: Constants.reviewCreated)
    }

    private func deleteReview(req: Request) async throws -> APIGenericMessageResponse {
        // check user privilegies
        let model: APIDeleteInfo = try convertRequestDataToModel(req: req)

        guard let reviewModel = try await reviewRepository.getReview(orderId: model.id) else {
            throw Abort(.notFound, reason: APIErrorMessage.Common.notFound)
        }

        try await reviewRepository.deleteReview(reviewModel)

        return APIGenericMessageResponse(message: Constants.reviewDeleted)
    }

    private enum Constants {
        static let reviewCreated = "Review created"
        static let reviewDeleted = "Review deleted"
    }
}

