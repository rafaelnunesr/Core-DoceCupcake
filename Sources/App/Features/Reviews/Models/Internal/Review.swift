import Fluent
import Vapor

final class Review: Model, Content {
    static let schema = "product_review"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Field(key: "order_id")
    var orderId: String

    @Field(key: "user_id")
    var userId: String

    @Field(key: "product_id")
    var productId: String

    @Field(key: "rate")
    var rate: Int

    @Field(key: "title")
    var title: String

    @Field(key: "text")
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
