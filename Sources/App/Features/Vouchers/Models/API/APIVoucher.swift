import Vapor

final class APIVoucher: Content {
    var createdAt: Date?
    var expiryDate: Date?
    var code: String
    var percentageDiscount: Double?
    var monetaryDiscount: Double?
    var availabilityCount: Int?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case expiryDate = "expiry_date"
        case code
        case percentageDiscount = "percentage_discount"
        case monetaryDiscount = "monetary_discount"
        case availabilityCount = "availability_count"
    }

    init(createdAt: Date? = nil,
         expiryDate: Date? = nil,
         code: String,
         percentageDiscount: Double? = nil,
         monetaryDiscount: Double? = nil,
         availabilityCount: Int? = nil) {
        self.createdAt = createdAt
        self.expiryDate = expiryDate
        self.code = code
        self.percentageDiscount = percentageDiscount
        self.monetaryDiscount = monetaryDiscount
        self.availabilityCount = availabilityCount
    }
}

extension APIVoucher {
    convenience init(from model: Voucher) {
        self.init(createdAt: model.createdAt, 
                  expiryDate: model.expiryDate,
                  code: model.code, 
                  percentageDiscount: model.percentageDiscount,
                  monetaryDiscount: model.monetaryDiscount,
                  availabilityCount: model.availabilityCount)
    }
}
