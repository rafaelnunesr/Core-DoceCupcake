import Foundation

@testable import App

struct MockAdmin {
    static func create(id: UUID? = UUID(),
                       createdAt: Date? = nil,
                       userName: String = "admin",
                       email: String = "email",
                       password: String = "password") -> Admin {
        Admin(id: id,
              createdAt: createdAt,
              userName: userName,
              email: email,
              password: password)
    }
    
    var mary = create(userName: "Mary")
}
