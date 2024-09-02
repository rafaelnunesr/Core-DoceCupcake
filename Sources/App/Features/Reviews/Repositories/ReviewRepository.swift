import FluentPostgresDriver
import Vapor

protocol ReviewRepositoryProtocol {
    func getReviewList(productId: String) async throws -> [Review]
    func getReview(orderId: String) async throws -> Review?
    func createReview(_ review: Review) async throws
    func deleteReview(_ review: Review) async throws
}

final class ReviewRepository: ReviewRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }

    func getReviewList(productId: String) async throws -> [Review] {
        try await Review.query(on: database)
            .filter(\.$productId == productId)
            .all()
    }

    func getReview(orderId: String) async throws -> Review? {
        try await Review.query(on: database)
            .filter(\.$orderId == orderId)
            .first()
    }

    func createReview(_ review: Review) async throws {
        try await review.create(on: database)
    }

    func deleteReview(_ review: Review) async throws {
        try await review.delete(on: database)
    }
}

