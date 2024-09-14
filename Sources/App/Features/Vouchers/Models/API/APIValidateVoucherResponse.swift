import Vapor

final class APIValidateVoucherResponse: Content, Codable, Equatable {
    var isValid: Bool
    var code: String
    var percentageDiscount: Double?
    var monetaryDiscount: Double?

    enum CodingKeys: String, CodingKey {
        case isValid
        case code
        case percentageDiscount = "percentage_discount"
        case monetaryDiscount = "monetary_discount"
    }

    init(isValid: Bool,
         code: String,
         percentageDiscount: Double? = nil,
         monetaryDiscount: Double? = nil,
         availabilityCount: Int? = nil) {
        self.isValid = isValid
        self.code = code
        self.percentageDiscount = percentageDiscount
        self.monetaryDiscount = monetaryDiscount
    }
    
    static func == (lhs: APIValidateVoucherResponse, rhs: APIValidateVoucherResponse) -> Bool {
        lhs.isValid == rhs.isValid &&
        lhs.code == rhs.code &&
        lhs.percentageDiscount == rhs.percentageDiscount &&
        lhs.monetaryDiscount == rhs.monetaryDiscount
    }
}

extension APIValidateVoucherResponse {
    convenience init(from model: Voucher) {
        var isValid = false
        
        if let expiryDate = model.expiryDate {
            let currentDate = Date()
            isValid = expiryDate > currentDate
        }
        
        self.init(isValid: isValid,
                  code: model.code,
                  percentageDiscount: model.percentageDiscount,
                  monetaryDiscount: model.monetaryDiscount)
    }
}

