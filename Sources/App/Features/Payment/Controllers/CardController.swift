import Foundation
import Vapor

protocol CardControllerProtocol: Sendable {
    func processOrder(_ creditCard: CreditCardRequest) async throws -> UUID
}

struct CardController: CardControllerProtocol {
    private let repository: CardRepositoryProtocol
    private var security: SecurityProtocol
    
    init(dependencyProvider: DependencyProviderProtocol, 
         repository: CardRepositoryProtocol) {
        self.repository = repository
        security = dependencyProvider.getSecurityInstance()
    }
    
    func processOrder(_ creditCard: CreditCardRequest) async throws -> UUID {
        return UUID()
    }
    
    private func isCardValid(_ card: CreditCardRequest) -> Bool {
        return isCardNumberValid(card.cardNumber) && isExpiryDateValid(expiryMonth: card.expiryMonth, expiryYear: card.expiryYear)
    }
    
    private func saveCard(for user: User, card: CreditCardRequest, lastDigits: String) async throws {
//        guard try await fetchCard(for: userId) != nil else {
//            return
//        }
        
//        let cardModel = CreditCard(from: card, user: user, lastDigits: lastDigits)
//        try await repository.saveCard(for: cardModel)
    }
    
    // Generic Luhn Algorithm Implementation
    private func isCardNumberValid(_ cardNumber: String) -> Bool {
        let digits = cardNumber.compactMap { Int(String($0)) }
        guard digits.count >= 13 && digits.count <= 19 else { return false }
        
        var sum = 0
        let reversedDigits = digits.reversed()
        for (index, digit) in reversedDigits.enumerated() {
            if index % 2 == 1 {
                let doubledDigit = digit * 2
                sum += doubledDigit > 9 ? doubledDigit - 9 : doubledDigit
            } else {
                sum += digit
            }
        }
        return sum % 10 == 0
    }
    
    private func isExpiryDateValid(expiryMonth: Int, expiryYear: Int) -> Bool {
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        return (expiryYear > currentYear) || (expiryYear == currentYear && expiryMonth >= currentMonth)
    }
}
