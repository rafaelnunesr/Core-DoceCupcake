import FluentPostgresDriver
import Vapor

protocol CardRepositoryProtocol {
    func fetchCard(for userId: UUID) async throws -> InternalCardModel?
    func saveCard(for card: InternalCardModel) async throws
    func deleteCard(for card: InternalCardModel) async throws
}

final class CardRepository: CardRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }
    
    func fetchCard(for userId: UUID) async throws -> InternalCardModel? {
        try await InternalCardModel.query(on: database)
            .filter(\.$userId == userId)
            .first()
    }
    
    func saveCard(for card: InternalCardModel) async throws {
        try await card.create(on: database)
    }
    
    func deleteCard(for card: InternalCardModel) async throws {
        try await card.delete(on: database)
    }
}
