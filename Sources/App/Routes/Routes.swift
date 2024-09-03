import Vapor

enum Routes: String {
    case productList
    case orders
    case packages
    case productTags
    case review
    case signin
    case admin
    case signup
    case vouchers
    
    var pathValue: PathComponent {
        PathComponent(stringLiteral: self.rawValue)
    }
}
