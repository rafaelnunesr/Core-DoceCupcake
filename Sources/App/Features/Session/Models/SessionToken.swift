import JWT
import Vapor

struct SessionToken: Content, Authenticatable, JWTPayload {
    private var expirationTime = Calendar.current.date(byAdding: .hour, value: 2, to: Date())
    
    var expiration: ExpirationClaim
    var userId: UUID
    
    init(userId: UUID) {
        self.userId = userId
        self.expiration = ExpirationClaim(value: expirationTime ?? Date())
    }
    
    func verify(using algorithm: some JWTKit.JWTAlgorithm) async throws {
        try expiration.verifyNotExpired()
    }
}

struct ClientTokenResponse: Content, Authenticatable {
    var token: String
}
