import Fluent
import Vapor

final class InternalProductModel: Model {
    static let schema = "product"

    var id: String?

    @Field(key: "product_id")
    var productId: String

    @Field(key: "code")
    var code: String

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Field(key: "name")
    var name: String

    @Field(key: "description")
    var description: String

    @Field(key: "current_price")
    var currentPrice: Double

    @OptionalField(key: "original_price")
    var originalPrice: Double?

    @OptionalField(key: "current_discount")
    var currentDiscount: Double?

    @Field(key: "stock_count")
    var stockCount: Double

    @Timestamp(key: "launch_date", on: .none)
    var launchDate: Date?

    @Field(key: "tags")
    var tags: [String]

    @Field(key: "allergic_tags")
    var allergicTags: [String]

    @Field(key: "nutritional_informations")
    var nutritionalInformations: String // update this

    internal init() { }

    init(id: String? = nil,
         productId: String,
         code: String,
         createdAt: Date,
         name: String,
         description: String,
         currentPrice: Double,
         originalPrice: Double?,
         currentDiscount: Double?,
         stockCount: Double,
         launchDate: Date,
         tags: [String],
         allergicTags: [String],
         nutritionalInformations: String) {
        self.id = id
        self.productId = productId
        self.code = code
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

extension InternalProductModel {
    convenience init(from product: APIProductModel) {
        self.init(productId: product.id,
                  code: product.code,
                  createdAt: Date(), // review this
                  name: product.name,
                  description: product.description,
                  currentPrice: product.currentPrice,
                  originalPrice: product.currentPrice,
                  currentDiscount: product.currentDiscount,
                  stockCount: product.stockCount,
                  launchDate: Date(), // review this,
                  tags: product.tags,
                  allergicTags: product.allergicTags,
                  nutritionalInformations: product.nutritionalInformations)
    }
}
