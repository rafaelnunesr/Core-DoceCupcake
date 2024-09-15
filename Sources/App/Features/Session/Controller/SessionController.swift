import FluentPostgresDriver
import Foundation
import Vapor

enum SessionControlAccess {
    case user
    case admin
    case unowned
}

protocol SessionControllerProtocol: Sendable {
    func validateSession(req: Request) async throws -> SessionControlAccess
    func fetchLoggedUserId(req: Request) async throws -> UUID
    func create(for userId: UUID, isAdmin: Bool, req: Request) async throws -> InternalSessionModel?
    func delete(for userId: UUID) async throws
}

struct SessionController: SessionControllerProtocol {
    private let repository: SessionRepositoryProtocol

    init(repository: SessionRepositoryProtocol) {
        self.repository = repository
    }

    func validateSession(req: Request) async throws -> SessionControlAccess {
        let session = try await req.jwt.verify(as: SessionToken.self)
        let user = try await repository.fetchSession(for: session.userId)
        
        let expirationTime = session.expiration.value
        let currentTime = Date()

        guard expirationTime > currentTime, let user else {
            return .unowned
        }
        
        return user.isAdmin ? .admin : .user
    }
    
    func fetchLoggedUserId(req: Request) async throws -> UUID {
        let session = try await req.jwt.verify(as: SessionToken.self)
        guard let user = try await repository.fetchSession(for: session.userId)
        else { throw APIResponseError.Common.internalServerError }
        return user.userId
    }

    func create(for userId: UUID, isAdmin: Bool, req: Request) async throws -> InternalSessionModel? {
        if try await repository.fetchSession(for: userId) != nil {
            try await delete(for: userId)
        }
        
        let sectionToken = createSessionToken(for: userId)
        let token = try await req.jwt.sign(sectionToken)
        let section = InternalSessionModel(expiryAt: sectionToken.expiration.value,
                                           userId: sectionToken.userId,
                                           token: token,
                                           isAdmin: isAdmin)
        try await repository.create(for: section)
        
        return try await repository.fetchSession(for: userId)
    }

    func delete(for userId: UUID) async throws {
        guard let section = try await repository.fetchSession(for: userId) else {
            throw APIResponseError.Common.internalServerError
        }

        try await repository.delete(for: section)
    }
    
    private func createSessionToken(for userId: UUID) -> SessionToken {
        return SessionToken(userId: userId)
    }
}
