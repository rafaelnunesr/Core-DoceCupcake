import Vapor

struct APIPackage: Content {
    var createdAt: Date?
    var code: String
    var name: String
    var description: String
    var width: Double
    var height: Double
    var length: Double
    var price: Double
    var stockCount: Int
}

extension APIPackage {
    init(from model: InternalPackageModel) {
        createdAt = model.createdAt
        code = model.code
        name = model.name
        description = model.description
        width = model.width
        height = model.height
        length = model.length
        price = model.price
        stockCount = model.stockCount
    }
}
