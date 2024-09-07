@testable import App

final class MockSecurity: SecurityProtocol {
    var isValid: Bool = true

    func isHashedValidCorrect(plainValue: String, hashValue: String) throws -> Bool {
        return isValid
    }
    
    func hashStringValue(_ value: String) throws -> String {
        fatalError()
    }
    
    func areCredentialsValid(email: String, password: String) -> Bool {
        fatalError()
    }
}
