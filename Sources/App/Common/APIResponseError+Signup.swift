import Vapor

extension APIResponseError {
    enum Signup {
        static var conflict: Abort {
            Abort(.conflict, reason: "User already registered")
        }
        
        static var unauthorized: Abort {
            Abort(.unauthorized, reason: "Invalid email/password")
        }
    }
}
