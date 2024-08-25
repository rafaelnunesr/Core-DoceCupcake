import Fluent
import Vapor

final class InternalVoucherModel: Model, Content {
    static let schema = "voucher"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "expiry_date", on: .none)
    var expiryDate: Date?

    @Field(key: "code")
    var code: String

    @OptionalField(key: "percentage_discount")
    var percentageDiscount: Double?

    @OptionalField(key: "monetary_discount")
    var monetaryDiscount: Double?

    @OptionalField(key: "availability_count")
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

extension InternalVoucherModel {
    convenience init(from model: APIVoucherModel) {
        self.init(createdAt: model.createdAt,
                  expiryDate: model.expiryDate,
                  code: model.code,
                  percentageDiscount: model.percentageDiscount,
                  monetaryDiscount: model.monetaryDiscount,
                  availabilityCount: model.availabilityCount)
    }
}
