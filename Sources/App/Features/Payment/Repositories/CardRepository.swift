import FluentPostgresDriver
import Vapor

protocol CardRepositoryProtocol: Sendable {
    func fetchCard(for cardNumber: String) async throws -> CreditCard?
    func saveCard(for card: CreditCard) async throws
    func deleteCard(for card: CreditCard) async throws
}

final class CardRepository: CardRepositoryProtocol {
    private let database: Database

    init(database: Database) {
        self.database = database
    }
    
    func fetchCard(for cardNumber: String) async throws -> CreditCard? {
        try await CreditCard.query(on: database)
            .filter(\.$cardNumber == cardNumber)
            .first()
    }
    
    func saveCard(for card: CreditCard) async throws {
        try await card.create(on: database)
    }
    
    func deleteCard(for card: CreditCard) async throws {
        try await card.delete(on: database)
    }
}
