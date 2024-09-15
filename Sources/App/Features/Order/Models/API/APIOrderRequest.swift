import Foundation

struct APIOrderRequest: Codable {
    var orderNumber: Int?
    let products: [APIProductOrderRequest]
    let deliveryFee: Double
    var voucherCode: String?
    let addressId: UUID
    let payment: CreditCardRequest
}

struct APIProductOrderRequest: Codable {
    let code: String
    let quantity: Double
    var voucherCode: String?
    var packageCode: String?
}
