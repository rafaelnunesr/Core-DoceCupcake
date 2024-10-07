import Foundation

@testable import App

struct MockCardController: CardControllerProtocol {
    func processOrder(_ card: CreditCardRequest, userId: UUID) async throws -> UUID? {
        UUID()
    }
}
