import Vapor

protocol SecurityProtocol {
    func getHashPassword(_ password: String) throws -> String
    func isPasswordCorrect(password: String, hashPassword: String) throws -> Bool
    func areCredentialsValid(email: String, password: String) -> Bool
}

final class Security: SecurityProtocol {
    func getHashPassword(_ password: String) throws -> String {
        try Bcrypt.hash(password)
    }
    
    func isPasswordCorrect(password: String, hashPassword: String) throws -> Bool {
        try Bcrypt.verify(password, created: hashPassword)
    }
    
    func areCredentialsValid(email: String, password: String) -> Bool {
        email.isValidEmail && password.isValidPassword
    }
}
