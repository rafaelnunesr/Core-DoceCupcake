import Foundation

@testable import App

struct MockInternalSectionModel {
    static func create(id: UUID? = nil,
                       createdAt: Date? = nil,
                       expiryDate: Date? = nil,
                       userId: UUID = UUID(),
                       token: String = "A",
                       isAdmin: Bool = false) -> InternalSectionModel {
        InternalSectionModel(id: id,
                             createdAt: createdAt,
                             expiryDate: expiryDate, 
                             userId: userId,
                             token: token,
                             isAdmin: isAdmin)
    }
    
    var defaultUser = create()
    var adminUser = create(isAdmin: true)
}
