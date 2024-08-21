import FluentPostgresDriver
import Foundation
import Vapor

typealias ProductAndReviewRepositoryProtocol = ProductRepositoryProtocol & ReviewRepositoryProtocol

struct ReviewController: RouteCollection {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: ProductAndReviewRepositoryProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: ProductAndReviewRepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
    }

    func boot(routes: RoutesBuilder) throws {
        let productRoutes = routes.grouped("review")
        productRoutes.get(":productId", use: getReviewList)
        productRoutes.post(use: createReview)
        productRoutes.delete(use: deleteReview)
    }

    private func getReviewList(req: Request) async throws -> APIReviewListResponse {
        let model: APIReviewModel = try convertRequestDataToModel(req: req)
        let result = try await repository.getReviewList(with: model.productId)

        let reviews = result.map { APIReviewResponse(from: $0) }
        return APIReviewListResponse(count: result.count, reviews: reviews)
    }

    private func createReview(req: Request) async throws -> APIGenericMessageResponse {
        let model: APICreateReviewModel = try convertRequestDataToModel(req: req)

        guard try await repository.getProduct(with: model.productId) != nil else {
            throw Abort(.notFound, reason: APIErrorMessage.Common.notFound)
        }

        guard try await repository.getReview(with: model.orderId) == nil else {
            throw Abort(.conflict, reason: APIErrorMessage.Common.conflict)
        }

        try await repository.createReview(InternalProductReview(from: model))

        return APIGenericMessageResponse(message: Constants.reviewCreated)
    }

    private func deleteReview(req: Request) async throws -> APIGenericMessageResponse {
        // check user privilegies
//        let model: APIDeleteInfo = try convertRequestDataToModel(req: req)
//
//        guard let tagModel = try await repository.getTag(with: model.id) else {
//            throw Abort(.notFound, reason: APIErrorMessage.Common.notFound)
//        }
//
//        try await repository.deleteReview(tagModel)
//
//        return APIGenericMessageResponse(message: Constants.reviewDeleted)

        fatalError()
    }

    private enum Constants {
        static let reviewCreated = "Review created"
        static let reviewDeleted = "Review deleted"
    }
}

