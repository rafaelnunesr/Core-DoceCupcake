import Foundation
import JWT

struct SectionJWTPayload: JWTPayload {
    var subject: SubjectClaim
    var expiration: ExpirationClaim
    var isAdmin: Bool
    
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case isAdmin = "admin"
    }
    
    func verify(using algorithm: some JWTAlgorithm) async throws {
        try self.expiration.verifyNotExpired()
    }
}
