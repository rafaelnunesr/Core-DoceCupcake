import Fluent
import Vapor

enum PackageDbField: String {
    case schema = "package"
    
    case code
    case createdAt = "created_at"
    case name
    case description
    case width
    case height
    case depth
    case price
    case stockCount = "stock_count"
    
    var fieldKey: FieldKey {
        return FieldKey(stringLiteral: self.rawValue)
    }
}

final class Package: DatabaseModelProtocol, @unchecked Sendable {
    static let schema = PackageDbField.schema.rawValue

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: PackageDbField.code.fieldKey)
    var code: String

    @Timestamp(key: PackageDbField.createdAt.fieldKey, on: .create)
    var createdAt: Date?

    @Field(key: PackageDbField.name.fieldKey)
    var name: String

    @Field(key: PackageDbField.description.fieldKey)
    var description: String

    @Field(key: PackageDbField.width.fieldKey)
    var width: Double

    @Field(key: PackageDbField.height.fieldKey)
    var height: Double

    @Field(key: PackageDbField.depth.fieldKey)
    var depth: Double

    @Field(key: PackageDbField.price.fieldKey)
    var price: Double

    @Field(key: PackageDbField.stockCount.fieldKey)
    var stockCount: Int

    internal init() {}

    init(id: UUID? = nil, 
         createdAt: Date? = nil, 
         code: String, 
         name: String,
         description: String, 
         width: Double,
         height: Double,
         depth: Double,
         price: Double,
         stockCount: Int) {
        self.id = id
        self.createdAt = createdAt
        self.code = code
        self.name = name
        self.description = description
        self.width = width
        self.height = height
        self.depth = depth
        self.price = price
        self.stockCount = stockCount
    }
}

extension Package {
    static var codeKey: KeyPath<Package, Field<String>> {
        \Package.$code
    }

    static var idKey: KeyPath<Package, IDProperty<Package, UUID>> {
        \Package.$id
    }
}

extension Package {
    convenience init(from model: APIPackage) {
        self.init(createdAt: model.createdAt,
                  code: model.code,
                  name: model.name,
                  description: model.description,
                  width: model.width,
                  height: model.height,
                  depth: model.depth,
                  price: model.price,
                  stockCount: model.stockCount)
    }
}
