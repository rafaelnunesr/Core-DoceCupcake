import Foundation

@testable import App

final class MockPackaging {
    static func create(id: UUID? = UUID(),
                       createdAt: TimeInterval? = Date().timeIntervalSince1970,
                       code: String = "A",
                       name: String = "Package A",
                       description: String = "description",
                       width: Double = 0,
                       height: Double = 0,
                       depth: Double = 0,
                       price: Double = 0,
                       stockCount: Int = 0) -> Package {
        Package(id: id,
                createdAt: Date(timeIntervalSince1970: createdAt ?? 0),
                code: code,
                name: name,
                description: description,
                width: width,
                height: height,
                depth: depth,
                price: price,
                stockCount: stockCount)
    }
    
    var packageA = create()
}
