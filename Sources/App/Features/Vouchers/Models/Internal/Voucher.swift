import Fluent
import Vapor

enum VoucherDbField: String {
    case schema = "voucher"
    
    case id
    case createdAt = "created_at"
    case expiryDate = "expiry_date"
    case code
    case percentageDiscount = "percentage_discount"
    case monetaryDiscount = "monetary_discount"
    case availabilityCount = "availability_count"
    
    var fieldKey: FieldKey {
        return FieldKey(stringLiteral: self.rawValue)
    }
}

final class Voucher: DatabaseModelProtocol {
    static let schema = VoucherDbField.schema.rawValue

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: VoucherDbField.createdAt.fieldKey, on: .create)
    var createdAt: Date?

    @Timestamp(key: VoucherDbField.expiryDate.fieldKey, on: .none)
    var expiryDate: Date?

    @Field(key: VoucherDbField.code.fieldKey)
    var code: String

    @OptionalField(key: VoucherDbField.percentageDiscount.fieldKey)
    var percentageDiscount: Double?

    @OptionalField(key: VoucherDbField.monetaryDiscount.fieldKey)
    var monetaryDiscount: Double?

    @OptionalField(key: VoucherDbField.availabilityCount.fieldKey)
    var availabilityCount: Int?

    internal init() { }

    init(id: UUID? = nil,
         createdAt: Date? = nil,
         expiryDate: Date? = nil,
         code: String,
         percentageDiscount: Double? = nil,
         monetaryDiscount: Double? = nil,
         availabilityCount: Int? = nil) {
        self.id = id
        self.createdAt = createdAt
        self.expiryDate = expiryDate
        self.code = code
        self.percentageDiscount = percentageDiscount
        self.monetaryDiscount = monetaryDiscount
        self.availabilityCount = availabilityCount
    }
}

extension Voucher {
    static var codeKey: KeyPath<Voucher, Field<String>> {
        \Voucher.$code
    }

    static var idKey: KeyPath<Voucher, IDProperty<Voucher, UUID>> {
        \Voucher.$id
    }
}

extension Voucher {
    convenience init(from model: APIVoucher) {
        self.init(createdAt: model.createdAt,
                  expiryDate: model.expiryDate,
                  code: model.code,
                  percentageDiscount: model.percentageDiscount,
                  monetaryDiscount: model.monetaryDiscount,
                  availabilityCount: model.availabilityCount)
    }
}
