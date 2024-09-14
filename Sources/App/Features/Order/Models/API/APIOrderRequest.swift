import Foundation

struct APIOrderRequest: Codable {
    var orderNumber: String?
    let products: [APIProductOrderRequest]
    let deliveryFee: Double
    var voucherCode: String?
    let addressCode: String
    let payment: CreditCardRequest
}

struct APIProductOrderRequest: Codable {
    let code: String
    let quantity: Double
    var voucherCode: String?
    var packageCode: String?
}
