import Foundation

@testable import App

struct MockUser {
    static func create(id: UUID? = UUID(),
                       createdAt: Date? = nil,
                       userName: String = "name",
                       email: String = "email",
                       password: String = "password",
                       imageUrl: String? = nil,
                       state: String = "A",
                       city: String = "B",
                       address: String = "D",
                       addressComplement: String? = nil) -> User {
        User(id: id,
              createdAt: createdAt,
              userName: userName,
              email: email,
              password: password,
              state: state,
              city: city,
              address: address,
              addressComplement: addressComplement)
    }
    
    var john = create(userName: "John")
}
