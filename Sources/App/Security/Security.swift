import Vapor

protocol SecurityProtocol {
    func getHashPassword(_ password: String) throws -> String
}

final class Security: SecurityProtocol {
    func getHashPassword(_ password: String) throws -> String {
        try Bcrypt.hash(password)
    }
}
