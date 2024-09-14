import FluentPostgresDriver
import Vapor

protocol CardRepositoryProtocol {
    func fetchCard(for userId: UUID) async throws -> CreditCard?
    func saveCard(for card: CreditCard) async throws
    func deleteCard(for card: CreditCard) async throws
}

final class CardRepository: CardRepositoryProtocol {
    private let database: Database

    init(database: Database) {
        self.database = database
    }
    
    func fetchCard(for userId: UUID) async throws -> CreditCard? {
        try await CreditCard.query(on: database)
            .filter(\.$userId == userId)
            .first()
    }
    
    func saveCard(for card: CreditCard) async throws {
        try await card.create(on: database)
    }
    
    func deleteCard(for card: CreditCard) async throws {
        try await card.delete(on: database)
    }
}
