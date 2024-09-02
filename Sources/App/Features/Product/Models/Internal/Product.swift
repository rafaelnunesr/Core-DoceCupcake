import Fluent
import Vapor

final class Product: Model {
    static let schema = "product"

    @ID(key: .id)
    var id: UUID?

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

    @Field(key: "nutritional_ids")
    var nutritionalIds: [UUID]

    internal init() { }

    init(id: UUID? = nil,
         productId: String,
         code: String,
         createdAt: Date? = nil,
         name: String,
         description: String,
         currentPrice: Double,
         originalPrice: Double?,
         currentDiscount: Double?,
         stockCount: Double,
         launchDate: Date?,
         tags: [String],
         allergicTags: [String],
         nutritionalIds: [UUID]) {
        self.id = id
        self.productId = productId
        self.code = code
        self.createdAt = createdAt
        self.name = name
        self.description = description
        self.currentPrice = currentPrice
        self.originalPrice = originalPrice
        self.currentDiscount = currentDiscount
        self.stockCount = stockCount
        self.launchDate = launchDate
        self.tags = tags
        self.allergicTags = allergicTags
        self.nutritionalIds = nutritionalIds
    }
}

extension Product {
    convenience init(from product: APIProduct, nutritionalIds: [UUID]) {
        self.init(productId: product.id,
                  code: product.code,
                  name: product.name,
                  description: product.description,
                  currentPrice: product.currentPrice,
                  originalPrice: product.originalPrice,
                  currentDiscount: product.currentDiscount,
                  stockCount: product.stockCount,
                  launchDate: product.launchDate.dateValue,
                  tags: product.tags.map { $0.code },
                  allergicTags: product.allergicTags.map { $0.code },
                  nutritionalIds: nutritionalIds)
    }
}
