import Vapor

struct APIVoucherListResponse: Content, Codable {
    let count: Int
    let vouchers: [APIVoucher]
}
