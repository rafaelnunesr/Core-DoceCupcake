import Foundation
import Vapor

struct APIOrderRequest: Codable, Content {
    let products: [APIProductOrderRequest]
    var voucherCode: String?
    let payment: CreditCardRequest
    
    enum CodingKeys: String, CodingKey {
        case products
        case voucherCode = "voucher_code"
        case payment
    }
}

struct APIProductOrderRequest: Codable {
    let code: String
    let quantity: Double
    var voucherCode: String?
    var packageCode: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case quantity
        case voucherCode = "voucher_code"
        case packageCode = "package_code"
    }
}
