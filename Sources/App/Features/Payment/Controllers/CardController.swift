import Foundation
import Vapor

protocol CardControllerProtocol: Sendable {
    func processOrder(_ card: CreditCardRequest, userId: UUID) async throws -> UUID?
}

struct CardController: CardControllerProtocol {
    private let repository: CardRepositoryProtocol
    private var security: SecurityProtocol
    
    init(dependencyProvider: DependencyProviderProtocol, 
         repository: CardRepositoryProtocol) {
        self.repository = repository
        security = dependencyProvider.getSecurityInstance()
    }
    
    func processOrder(_ card: CreditCardRequest, userId: UUID) async throws -> UUID? {
        if isCardValid(card) {
            return try await saveCard(for: userId, card: card, lastDigits: String(card.cardNumber.suffix(4)))
        }
        throw APIResponseError.Common.badRequest // improve this
    }
    
    private func isCardValid(_ card: CreditCardRequest) -> Bool {
        return isCardNumberValid(card.cardNumber) && isExpiryDateValid(expiryMonth: card.expiryMonth, expiryYear: card.expiryYear)
    }
    
    private func saveCard(for userId: UUID, card: CreditCardRequest, lastDigits: String) async throws -> UUID? {
        if let card = try await repository.fetchCard(for: card.cardNumber) {
            return card.id
        }
        
        let model = CreditCard(from: card, userId: userId, lastDigits: lastDigits)
        try await repository.saveCard(for: model)
        
        if let card = try await repository.fetchCard(for: card.cardNumber) {
            return card.id
        }
        
        return nil
    }
    
    private func isCardNumberValid(_ cardNumber: String) -> Bool {
        return cardNumber.count >= 13 && cardNumber.count <= 19
    }
    
    private func isExpiryDateValid(expiryMonth: Int, expiryYear: Int) -> Bool {
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        return (expiryYear > currentYear) || (expiryYear == currentYear && expiryMonth >= currentMonth)
    }
}
