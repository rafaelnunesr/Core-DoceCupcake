import Foundation
import Vapor

protocol SectionSecurityProtocol {
    func validateSection(_ req: Request, isManagerUser: Bool) async throws -> Bool
}

final class SectionSecurity: SectionSecurityProtocol {
    func validateSection(_ req: Request, isManagerUser: Bool) async throws -> Bool {
        guard let token = req.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized, reason: APIErrorMessage.Security.missingToken)
        }

        let payload = try req.jwt.verify(token, as: MyJWTPayload.self)

        return true
    }
}
