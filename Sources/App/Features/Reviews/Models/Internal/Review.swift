import Fluent
import Vapor

enum ReviewDbField: String {
    case schema = "review"
    
    case createdAt = "created_at"
    case orderId = "order_id"
    case userId = "user_id"
    case userName = "user_name"
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
    var orderId: UUID

    @Field(key: ReviewDbField.userId.fieldKey)
    var userId: UUID
    
    @Field(key: ReviewDbField.userName.fieldKey)
    var userName: String

    @Field(key: ReviewDbField.productId.fieldKey)
    var productId: UUID

    @Field(key: ReviewDbField.rate.fieldKey)
    var rate: Int

    @Field(key: ReviewDbField.title.fieldKey)
    var title: String

    @Field(key: ReviewDbField.text.fieldKey)
    var text: String

    internal init() {}

    init(id: UUID? = nil,
         createdAt: Date? = nil,
         orderId: UUID,
         userId: UUID,
         userName: String,
         productId: UUID,
         rate: Int,
         title: String,
         text: String) {
        self.id = id
        self.createdAt = createdAt
        self.orderId = orderId
        self.userId = userId
        self.userName = userName
        self.productId = productId
        self.rate = rate
        self.title = title
        self.text = text
    }

}

extension Review {
    convenience init(from review: APICreateReview, userId: UUID, userName: String) {
        self.init(orderId: review.orderId.uuid,
                  userId: userId,
                  userName: userName,
                  productId: review.productId.uuid,
                  rate: review.rate,
                  title: review.title,
                  text: review.text)
    }
}
