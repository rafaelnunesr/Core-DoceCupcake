import Fluent
import Vapor

final class InternalProductModel: Model, Content {
    static let schema = "product"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Field(key: "name")
    var name: String

    @Field(key: "description")
    var description: String

    @Field(key: "original_price")
    var originalPrice: Double

    @Field(key: "current_discount")
    var currentDiscount: Double

    @Field(key: "stock_count")
    var stockCount: Double

    @Timestamp(key: "launch_date", on: .none)
    var launchDate: Date?

    @Field(key: "tags")
    var tags: String  // update this

    @Field(key: "allergic_tags")
    var allergicTags: String  // update this

    @Field(key: "nutritional_informations")
    var nutritionalInformations: String // update this

    internal init() { }

    init(id: UUID? = nil,
         createdAt: Date,
         name: String,
         description: String,
         originalPrice: Double,
         currentDiscount: Double,
         stockCount: Double,
         launchDate: Date,
         tags: String,
         allergicTags: String,
         nutritionalInformations: String) {
        self.id = id
        self.createdAt = createdAt
        self.name = name
        self.description = description
        self.originalPrice = originalPrice
        self.currentDiscount = currentDiscount
        self.stockCount = stockCount
        self.launchDate = launchDate
        self.tags = tags
        self.allergicTags = allergicTags
        self.nutritionalInformations = nutritionalInformations
    }
}
