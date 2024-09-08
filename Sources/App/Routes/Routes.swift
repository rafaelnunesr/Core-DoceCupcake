import Vapor

enum Routes: String {
    case admin
    case vouchers
    case signin
    case signup
    case products
    case productTags
    case packages
    
    var path: PathComponent {
        PathComponent(stringLiteral: self.rawValue)
    }
}
