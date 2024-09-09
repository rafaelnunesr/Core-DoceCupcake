import Foundation

@testable import App

struct MockInternalSessionModel {
    static func create(id: UUID? = nil,
                       createdAt: Date? = nil,
                       expiryAt: Date? = nil,
                       userId: UUID = UUID(),
                       token: String = "A",
                       isAdmin: Bool = false) -> InternalSessionModel {
        InternalSessionModel(id: id,
                             createdAt: createdAt,
                             expiryAt: expiryAt,
                             userId: userId,
                             token: token,
                             isAdmin: isAdmin)
    }
    
    var defaultUser = create()
    var adminUser = create(isAdmin: true)
}
