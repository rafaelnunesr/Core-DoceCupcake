import Fluent
import Vapor

final class InternalPackageModel: Model, Content {
    static let schema = "package"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Field(key: "code")
    var code: String

    @Field(key: "name")
    var name: String

    @Field(key: "description")
    var description: String

    @Field(key: "width")
    var width: Double

    @Field(key: "height")
    var height: Double

    @Field(key: "length")
    var length: Double

    @Field(key: "price")
    var price: Double

    @Field(key: "stock_count")
    var stockCount: Int

    internal init() {}

    init(id: UUID? = nil, 
         createdAt: Date? = nil, 
         code: String, 
         name: String,
         description: String, 
         width: Double,
         height: Double,
         length: Double,
         price: Double,
         stockCount: Int) {
        self.id = id
        self.createdAt = createdAt
        self.code = code
        self.name = name
        self.description = description
        self.width = width
        self.height = height
        self.length = length
        self.price = price
        self.stockCount = stockCount
    }
}

extension InternalPackageModel {
    convenience init(from model: APIPackage) {
        self.init(createdAt: model.createdAt,
                  code: model.code,
                  name: model.name,
                  description: model.description,
                  width: model.width,
                  height: model.height,
                  length: model.length,
                  price: model.price,
                  stockCount: model.stockCount)
    }
}
