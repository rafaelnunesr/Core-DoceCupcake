import Foundation

struct APIOrderRequest: Codable {
    let products: [APIProductOrderRequest]
    let deliveryFee: Double
    var voucherId: UUID?
    let addressId: UUID
    let payment: CreditCardRequest
}

struct APIProductOrderRequest: Codable {
    let code: String
    let quantity: Double
    var voucherId: UUID?
    var packageId: UUID?
}
