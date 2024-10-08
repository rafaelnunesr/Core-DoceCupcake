import Foundation

@testable import App

struct MockAPIOrderRequest {
    static func create(products: [APIProductOrderRequest] = [MockAPIProductOrderRequest().productA],
                       voucherCode: String? = nil,
                       payment: CreditCardRequest = MockCreditCardRequest().creditCardA) -> APIOrderRequest {
        APIOrderRequest(products: products, voucherCode: voucherCode, payment: payment)
    }
    
    var orderA = create()
}
