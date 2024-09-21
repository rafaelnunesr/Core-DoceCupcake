import Foundation

@testable import App

struct MockUser {
    static func create(id: UUID? = UUID(),
                       createdAt: Date? = nil,
                       userName: String = "name",
                       email: String = "email",
                       password: String = "password",
                       imageUrl: String? = nil) -> User {
        User(id: id,
              createdAt: createdAt,
              userName: userName,
              email: email,
              password: password)
    }
    
    var john = create(userName: "John")
}
