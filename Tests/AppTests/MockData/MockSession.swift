@testable import App

import Foundation

struct MockSession {
    static func create(id: UUID? = UUID(),
                       createdAt: TimeInterval? = Date().timeIntervalSince1970,
                       expiryAt: TimeInterval? = Date().timeIntervalSince1970,
                       userId: UUID = UUID(),
                       token: String = "",
                       isAdmin: Bool = false) -> InternalSessionModel {
        InternalSessionModel(id: id,
                             createdAt: Date(timeIntervalSince1970: createdAt ?? 0),
                             expiryAt: Date(timeIntervalSince1970: createdAt ?? 0),
                             userId: userId,
                             token: token,
                             isAdmin: isAdmin)
    }
    
    var user = create()
    var admin = create(isAdmin: true)
}
