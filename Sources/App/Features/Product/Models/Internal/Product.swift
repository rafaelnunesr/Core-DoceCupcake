import Fluent
import Vapor

enum ProductDbField: String {
    case schema = "product"
    
    case id
    case createdAt = "created_at"
    case code
    case name
    case description
    case imageUrl = "imag_url"
    case label
    case currentPrice = "current_price"
    case originalPrice = "original_price"
    case voucherCode = "voucher_code"
    case stockCount = "stock_count"
    case launchDate = "launch_date"
    case tags = "tags"
    case allergicInfo = "allergic_info"
    case nutritionalIds = "nutritional_ids"
    case isNew = "is_new"
    case isHighlightedSale = "highlighted_sale"
    case isHighlightedNew = "highlighted_new"
    
    var fieldKey: FieldKey {
        return FieldKey(stringLiteral: self.rawValue)
    }
}

final class Product: Model {
    static let schema = ProductDbField.schema.rawValue

    @ID(key: .id)
    var id: UUID?
    
    @Timestamp(key: ProductDbField.createdAt.fieldKey, on: .create)
    var createdAt: Date?

    @Field(key: ProductDbField.code.fieldKey)
    var code: String

    @Field(key: ProductDbField.name.fieldKey)
    var name: String

    @Field(key: ProductDbField.description.fieldKey)
    var description: String
    
    @OptionalField(key: ProductDbField.imageUrl.fieldKey)
    var imageUrl: String?
    
    @OptionalField(key: ProductDbField.label.fieldKey)
    var label: String?

    @Field(key: ProductDbField.currentPrice.fieldKey)
    var currentPrice: Double

    @OptionalField(key: ProductDbField.originalPrice.fieldKey)
    var originalPrice: Double?

    @OptionalField(key: ProductDbField.voucherCode.fieldKey)
    var voucherCode: String?

    @Field(key: ProductDbField.stockCount.fieldKey)
    var stockCount: Double

    @Timestamp(key: ProductDbField.launchDate.fieldKey, on: .none)
    var launchDate: Date?

    @Field(key: ProductDbField.tags.fieldKey)
    var tags: [String]

    @Field(key: ProductDbField.allergicInfo.fieldKey)
    var allergicInfo: AllergicInfo

    @Field(key: ProductDbField.nutritionalIds.fieldKey)
    var nutritionalIds: [UUID]
    
    @Field(key: ProductDbField.isNew.fieldKey)
    var isNew: Bool
    
    @Field(key: ProductDbField.isHighlightedSale.fieldKey)
    var isHighlightedSale: Bool
    
    @Field(key: ProductDbField.isHighlightedNew.fieldKey)
    var isHighlightedNew: Bool
    
    internal init() { }

    init(id: UUID? = nil,
         createdAt: Date? = nil,
         code: String,
         name: String,
         description: String,
         imageUrl: String? = nil,
         label: String? = nil,
         currentPrice: Double,
         originalPrice: Double?,
         voucherCode: String? = nil,
         stockCount: Double,
         launchDate: Date?,
         tags: [String],
         allergicInfo: AllergicInfo,
         nutritionalIds: [UUID],
         isNew: Bool = false,
         isHighlightedSale: Bool = false,
         isHighlightedNew: Bool = false) {
        self.id = id
        self.code = code
        self.createdAt = createdAt
        self.name = name
        self.description = description
        self.imageUrl = imageUrl
        self.label = label
        self.currentPrice = currentPrice
        self.originalPrice = originalPrice
        self.voucherCode = voucherCode
        self.stockCount = stockCount
        self.launchDate = launchDate
        self.tags = tags
        self.allergicInfo = allergicInfo
        self.nutritionalIds = nutritionalIds
        self.isNew = isNew
        self.isHighlightedSale = isHighlightedSale
        self.isHighlightedNew = isHighlightedNew
    }
}

extension Product {
    convenience init(from product: APIProduct, nutritionalIds: [UUID]) {
        self.init(code: product.code,
                  name: product.name,
                  description: product.description,
                  imageUrl: product.imageUrl,
                  currentPrice: product.currentPrice,
                  originalPrice: product.originalPrice,
                  voucherCode: product.voucherCode,
                  stockCount: product.stockCount,
                  launchDate: product.launchDate,
                  tags: product.tags.map { $0.code },
                  allergicInfo: product.allergicInfo,
                  nutritionalIds: nutritionalIds,
                  isNew: product.isNew,
                  isHighlightedSale: product.isHighlightSale,
                  isHighlightedNew: product.isHighlightNew)
    }
}
