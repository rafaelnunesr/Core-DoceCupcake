import Foundation

@testable import App

struct MockCreditCardRequest {
    static func create(cardHolderName: String = "John Smith",
                       cardNumber: String = "1234",
                       expiryMonth: Int = 1,
                       expiryYear: Int = 2,
                       cvv: String = "123") -> CreditCardRequest {
        CreditCardRequest(cardHolderName: cardHolderName,
                          cardNumber: cardNumber,
                          expiryMonth: expiryMonth,
                          expiryYear: expiryYear,
                          cvv: cvv)
    }
    
    var creditCardA = create()
}
