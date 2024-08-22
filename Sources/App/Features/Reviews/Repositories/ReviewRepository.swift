import FluentPostgresDriver
import Vapor

protocol ReviewRepositoryProtocol {
    func getReviewList(productId: String) async throws -> [InternalProductReview]
    func getReview(orderId: String) async throws -> InternalProductReview?
    func createReview(_ review: InternalProductReview) async throws
    func deleteReview(_ review: InternalProductReview) async throws
}

final class ReviewRepository: ReviewRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }

    func getReviewList(productId: String) async throws -> [InternalProductReview] {
        try await InternalProductReview.query(on: database)
            .filter(\.$productId == productId)
            .all()
    }

    func getReview(orderId: String) async throws -> InternalProductReview? {
        try await InternalProductReview.query(on: database)
            .filter(\.$orderId == orderId)
            .first()
    }

    func createReview(_ review: InternalProductReview) async throws {
        try await review.create(on: database)
    }

    func deleteReview(_ review: InternalProductReview) async throws {
        try await review.delete(on: database)
    }
}

