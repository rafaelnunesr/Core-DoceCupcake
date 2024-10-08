import Foundation

@testable import App

struct MockAPIProductOrderRequest {
    static func create(code: String = "1",
                       quantity: Double = 1,
                       voucherCode: String? = nil,
                       packageCode: String? = nil) -> APIProductOrderRequest {
        APIProductOrderRequest(code: code,
                               quantity: quantity,
                               voucherCode: voucherCode,
                               packageCode: packageCode)
    }
    
    var productA = create()
}
