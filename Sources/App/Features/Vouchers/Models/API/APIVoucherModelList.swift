import Vapor

struct APIVoucherModelList: Content {
    let count: Int
    let vouchers: [APIVoucher]
}
