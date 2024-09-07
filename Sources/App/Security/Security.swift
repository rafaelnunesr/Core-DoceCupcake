import Vapor

protocol SecurityProtocol: Sendable {
    func hashStringValue(_ value: String) throws -> String
    func isHashedValidCorrect(plainValue: String, hashValue: String) throws -> Bool
    func areCredentialsValid(email: String, password: String) -> Bool
}

final class Security: SecurityProtocol {
    func hashStringValue(_ value: String) throws -> String {
        try Bcrypt.hash(value)
    }
    
    func isHashedValidCorrect(plainValue: String, hashValue: String) throws -> Bool {
        try Bcrypt.verify(plainValue, created: hashValue)
    }
    
    func areCredentialsValid(email: String, password: String) -> Bool {
        email.isValidEmail && password.isValidPassword
    }
}
