import JWT
import Vapor

struct SessionToken: Content, Authenticatable, JWTPayload {
    private var expirationTime = Date().timeIntervalSince1970 + 3600
    
    var expiration: ExpirationClaim
    var userId: UUID
    
    init(userId: UUID) {
        self.userId = userId
        self.expiration = ExpirationClaim(value: Date().addingTimeInterval(expirationTime))
    }
    
    func verify(using algorithm: some JWTKit.JWTAlgorithm) async throws {
        try expiration.verifyNotExpired()
    }
}

struct ClientTokenResponse: Content, Authenticatable {
    var token: String
}
