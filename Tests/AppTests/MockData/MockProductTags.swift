@testable import App

import Foundation

struct MockProductTags {
    static func create(id: UUID? = UUID(), 
                       code: String = "A",
                       description: String = .empty) -> ProductTag {
        ProductTag(id: id, code: code, description: description)
    }
    
    var tagA = create()
}
