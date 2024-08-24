import Foundation
import JWT

struct MyJWTPayload: JWTPayload {
    var userId: UUID
    var sectionId: UUID

    // This function is used to verify claims (e.g., expiration)
    func verify(using signer: JWTSigner) throws {
        // Add any custom verification logic here if needed
    }
}
