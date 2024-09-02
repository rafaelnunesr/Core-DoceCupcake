import Fluent
import Vapor

final class CreditCard: Model {
    static let schema = "credit_card"

    @ID(key: .id)
    var id: UUID?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @OptionalField(key: "user_id")
    var userId: UUID?
    
    @Field(key: "card_holder_name")
    var cardHolderName: String

    @Field(key: "card_number")
    var cardNumber: String
    
    @Field(key: "last_digits")
    var lastDigits: String

    @Field(key: "expiry_month")
    var expiryMonth: Int

    @Field(key: "expiry_year")
    var expiryYear: Int

    @Field(key: "cvv")
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
