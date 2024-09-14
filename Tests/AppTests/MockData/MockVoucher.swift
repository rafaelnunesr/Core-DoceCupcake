@testable import App

import Foundation

struct MockAPIVoucher {
    static func create(createdAt: TimeInterval? = Date().timeIntervalSince1970,
                       expiryDate: TimeInterval? = Date().timeIntervalSince1970,
                       code: String = "A",
                       percentageDiscount: Double? = 0,
                       monetaryDiscount: Double? = 0,
                       availabilityCount: Int? = 0) -> APIVoucher {
        return APIVoucher(createdAt: Date(timeIntervalSince1970: createdAt ?? 0),
                          expiryDate: Date(timeIntervalSince1970: expiryDate ?? 0),
                          code: code,
                          percentageDiscount: percentageDiscount,
                          monetaryDiscount: monetaryDiscount,
                          availabilityCount: availabilityCount)
    }

    var voucherA = create()
}

struct MockAPIVoucherList {
    static func create(count: Int = 0,
                       vouchers: [APIVoucher] = []) -> APIVoucherListResponse {
        APIVoucherListResponse(count: count, vouchers: vouchers)
    }
    
    var listA = create(count: 1, 
                       vouchers: [MockAPIVoucher().voucherA])
}

final class MockVoucher {
    static func create(id: UUID? = UUID(),
                       createdAt: TimeInterval? = Date().timeIntervalSince1970,
                       expiryDate: TimeInterval? = Date().timeIntervalSince1970,
                       code: String = "A",
                       percentageDiscount: Double? = 0,
                       monetaryDiscount: Double? = 0,
                       availabilityCount: Int? = 0) -> Voucher {
        Voucher(id: id,
                createdAt: Date(timeIntervalSince1970: createdAt ?? 0),
                expiryDate: Date(timeIntervalSince1970: expiryDate ?? 0),
                code: code,
                percentageDiscount: percentageDiscount,
                monetaryDiscount: monetaryDiscount,
                availabilityCount: availabilityCount)
    }
    
    var voucherA = create()
}
