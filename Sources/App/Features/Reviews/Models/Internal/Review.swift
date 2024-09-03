import Fluent
import Vapor

enum ReviewDbField: String {
    case schema = "review"
    
    case createdAt = "created_at"
    case orderId = "order_id"
    case userId = "user_id"
    case productId = "product_id"
    case rate
    case title
    case text
    
    var fieldKey: FieldKey {
        return FieldKey(stringLiteral: self.rawValue)
    }
}

final class Review: Model, Content {
    static let schema = ReviewDbField.schema.rawValue

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: ReviewDbField.createdAt.fieldKey, on: .create)
    var createdAt: Date?

    @Field(key: ReviewDbField.orderId.fieldKey)
    var orderId: String

    @Field(key: ReviewDbField.userId.fieldKey)
    var userId: String

    @Field(key: ReviewDbField.productId.fieldKey)
    var productId: String

    @Field(key: ReviewDbField.rate.fieldKey)
    var rate: Int

    @Field(key: ReviewDbField.title.fieldKey)
    var title: String

    @Field(key: ReviewDbField.text.fieldKey)
    var text: String

    internal init() {}

    init(id: UUID? = nil,
         createdAt: Date? = nil,
         orderId: String,
         userId: String,
         productId: String,
         rate: Int,
         title: String,
         text: String) {
        self.id = id
        self.createdAt = createdAt
        self.orderId = orderId
        self.userId = userId
        self.productId = productId
        self.rate = rate
        self.title = title
        self.text = text
    }

}

extension Review {
    convenience init(from review: APICreateReview) {
        self.init(orderId: review.orderId,
                  userId: review.userId,
                  productId: review.productId,
                  rate: review.rate,
                  title: review.title,
                  text: review.text)
    }
}
