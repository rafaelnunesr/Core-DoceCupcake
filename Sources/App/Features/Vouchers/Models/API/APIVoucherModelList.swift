import Vapor

struct APIVoucherModelList: Content, Codable {
    let count: Int
    let vouchers: [APIVoucher]
}
