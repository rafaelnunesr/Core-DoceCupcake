import FluentPostgresDriver
import Vapor

protocol CardRepositoryProtocol {
    func fetchCard(for userId: UUID) async throws -> CreditCard?
    func saveCard(for card: CreditCard) async throws
    func deleteCard(for card: CreditCard) async throws
}

final class CardRepository: CardRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }
    
    func fetchCard(for userId: UUID) async throws -> CreditCard? {
        try await CreditCard.query(on: database)
            .filter(\.$user.$id == userId)
            .first()
    }
    
    func saveCard(for card: CreditCard) async throws {
        try await card.create(on: database)
    }
    
    func deleteCard(for card: CreditCard) async throws {
        try await card.delete(on: database)
    }
}
