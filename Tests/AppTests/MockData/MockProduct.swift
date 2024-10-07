import Foundation

@testable import App

struct MockProduct {
    static func create(id: UUID? = UUID(),
                       createdAt: TimeInterval? = Date().timeIntervalSince1970,
                       code: String = "code",
                       name: String = "name",
                       description: String = "description",
                       imageUrl: String? = "image_url", 
                       currentPrice: Double = 1,
                       originalPrice: Double? = 2,
                       voucherCode: String? = "voucher_code",
                       stockCount: Double = 1,
                       launchDate: TimeInterval? = Date().timeIntervalSince1970,
                       tags: [String] = [],
                       allergicInfo: AllergicInfo = AllergicInfo(),
                       nutritionalIds: [UUID] = [],
                       isNew: Bool = true) -> Product {
        Product(id: id,
                createdAt: Date(timeIntervalSince1970: createdAt ?? 0),
                code: code,
                name: name,
                description: description,
                imageUrl: imageUrl,
                currentPrice: currentPrice,
                originalPrice: originalPrice,
                voucherCode: voucherCode,
                stockCount: stockCount,
                launchDate: Date(timeIntervalSince1970: createdAt ?? 0),
                tags: tags,
                allergicInfo: allergicInfo,
                nutritionalIds: nutritionalIds,
                isNew: isNew)
    }
    
    var productA = create(name: "productA")
}
