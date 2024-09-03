import Fluent
import Vapor

enum CreditCardDbField: String {
    case schema = "credit_card"
    
    case id
    case createdAt = "created_at"
    case userId = "user_id"
    case cardHolderName = "card_holder_name"
    case cardNumber = "card_number"
    case lastDigits = "last_digits"
    case expiryMonth = "expiry_month"
    case expiryYear = "expiry_year"
    case cvv
    
    var fieldKey: FieldKey {
        return FieldKey(stringLiteral: self.rawValue)
    }
}

final class CreditCard: Model {
    static let schema = CreditCardDbField.schema.rawValue

    @ID(key: .id)
    var id: UUID?
    
    @Timestamp(key: CreditCardDbField.createdAt.fieldKey, on: .create)
    var createdAt: Date?
    
    @OptionalField(key: CreditCardDbField.userId.fieldKey)
    var userId: UUID?
    
    @Field(key: CreditCardDbField.cardHolderName.fieldKey)
    var cardHolderName: String

    @Field(key: CreditCardDbField.cardNumber.fieldKey)
    var cardNumber: String
    
    @Field(key: CreditCardDbField.lastDigits.fieldKey)
    var lastDigits: String

    @Field(key: CreditCardDbField.expiryMonth.fieldKey)
    var expiryMonth: Int

    @Field(key: CreditCardDbField.expiryYear.fieldKey)
    var expiryYear: Int

    @Field(key: CreditCardDbField.cvv.fieldKey)
    var cvv: String

    internal init() { }

    init(id: UUID? = nil,
         createdAt: Date? = nil,
         userId: UUID? = nil,
         cardHolderName: String,
         cardNumber: String,
         lastDigits: String,
         expiryMonth: Int,
         expiryYear: Int,
         cvv: String) {
        self.id = id
        self.createdAt = createdAt
        self.userId = userId
        self.cardHolderName = cardHolderName
        self.cardNumber = cardNumber
        self.lastDigits = lastDigits
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.cvv = cvv
    }
}

extension CreditCard {
    convenience init(from model: CreditCardRequest, userId: UUID, lastDigits: String) {
        self.init(userId: userId,
                  cardHolderName: model.cardHolderName,
                  cardNumber: model.cardNumber,
                  lastDigits: lastDigits,
                  expiryMonth: model.expiryMonth,
                  expiryYear: model.expiryYear,
                  cvv: model.cvv)
    }
}
