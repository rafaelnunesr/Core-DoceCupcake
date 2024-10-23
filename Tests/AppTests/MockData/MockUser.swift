import Foundation

@testable import App

struct MockUser {
    static func create(id: UUID? = UUID(),
                       createdAt: Date? = nil,
                       userName: String = "name",
                       email: String = "email",
                       password: String = "password",
                       imageUrl: String? = nil,
                       phoneNumber: String = "11 999") -> User {
        User(id: id,
             createdAt: createdAt,
             userName: userName,
             email: email,
             password: password,
             phoneNumber: phoneNumber)
    }
    
    var john = create(userName: "John")
}
