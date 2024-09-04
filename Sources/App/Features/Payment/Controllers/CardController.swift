//import Foundation
//import Vapor
//
//protocol CardControllerProtocol {
//    func isCardValid(_ card: CreditCardRequest) -> Bool
//    func fetchCard(for userId: UUID) async throws -> CreditCard?
//    func saveCard(for userId: UUID, card: CreditCardRequest, lastDigits: String) async throws
//    func deleteCard(for userId: UUID) async throws
//}
//
//struct CardController: CardControllerProtocol {
//    private let dependencyProvider: DependencyProviderProtocol
//    private let repository: CardRepositoryProtocol
//    private var security: SecurityProtocol
//    
//    init(dependencyProvider: DependencyProviderProtocol, 
//         repository: CardRepositoryProtocol) {
//        self.dependencyProvider = dependencyProvider
//        self.repository = repository
//        security = dependencyProvider.getSecurityInstance()
//    }
//    
//    func isCardValid(_ card: CreditCardRequest) -> Bool {
//        return isCardNumberValid(card.cardNumber) && isExpiryDateValid(expiryMonth: card.expiryMonth, expiryYear: card.expiryYear)
//    }
//    
//    func fetchCard(for userId: UUID) async throws -> CreditCard? {
//        try await repository.fetchCard(for: userId)
//    }
//    
//    func saveCard(for userId: UUID, card: CreditCardRequest, lastDigits: String) async throws {
//        guard try await fetchCard(for: userId) != nil else {
//            return
//        }
//        
//        let cardModel = CreditCard(from: card, userId: userId, lastDigits: lastDigits)
//        try await repository.saveCard(for: cardModel)
//    }
//    
//    func deleteCard(for userId: UUID) async throws {
//        guard let card = try await fetchCard(for: userId) else {
//            throw Abort(.notFound, reason: APIErrorMessage.Common.notFound)
//        }
//        
//        try await repository.deleteCard(for: card)
//    }
//    
//    // Generic Luhn Algorithm Implementation
//    private func isCardNumberValid(_ cardNumber: String) -> Bool {
//        let digits = cardNumber.compactMap { Int(String($0)) }
//        guard digits.count >= 13 && digits.count <= 19 else { return false }
//        
//        var sum = 0
//        let reversedDigits = digits.reversed()
//        for (index, digit) in reversedDigits.enumerated() {
//            if index % 2 == 1 {
//                let doubledDigit = digit * 2
//                sum += doubledDigit > 9 ? doubledDigit - 9 : doubledDigit
//            } else {
//                sum += digit
//            }
//        }
//        return sum % 10 == 0
//    }
//    
//    private func isExpiryDateValid(expiryMonth: Int, expiryYear: Int) -> Bool {
//        let currentYear = Calendar.current.component(.year, from: Date())
//        let currentMonth = Calendar.current.component(.month, from: Date())
//        return (expiryYear > currentYear) || (expiryYear == currentYear && expiryMonth >= currentMonth)
//    }
//}
