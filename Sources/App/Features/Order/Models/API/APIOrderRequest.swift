import Foundation

struct APIOrderRequest: Codable {
    let products: [APIProductOrderRequest]
    var voucherCode: String?
    let addressId: UUID
    let payment: CreditCardRequest
    
    enum CodingKeys: String, CodingKey {
        case products
        case voucherCode = "voucher_code"
        case addressId = "address_id"
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
