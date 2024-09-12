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
    func getLoggedUserId(req: Request) async throws -> UUID
    func createSession(for userId: UUID, isAdmin: Bool, req: Request) async throws -> InternalSessionModel?
    func deleteSession(for userId: UUID) async throws
}

struct SessionController: SessionControllerProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: SessionRepositoryProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: SessionRepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
    }

    func validateSession(req: Request) async throws -> SessionControlAccess {
        let session = try await req.jwt.verify(as: SessionToken.self)
        let user = try await repository.getSession(for: session.userId)
        
        let expirationTime = session.expiration.value
        let currentTime = Date()

        guard expirationTime > currentTime, let user else {
            return .unowned
        }
        
        return user.isAdmin ? .admin : .user
    }
    
    func getLoggedUserId(req: Request) async throws -> UUID {
        let session = try await req.jwt.verify(as: SessionToken.self)
        guard let user = try await repository.getSession(for: session.userId)
        else { throw APIError.internalServerError }
        return user.userId
    }

    func createSession(for userId: UUID, isAdmin: Bool, req: Request) async throws -> InternalSessionModel? {
        try await deleteSession(for: userId)
        
        let sectionToken = createSessionToken(for: userId)
        let token = try await req.jwt.sign(sectionToken)
        let section = InternalSessionModel(expiryAt: sectionToken.expiration.value, userId: sectionToken.userId, token: token, isAdmin: isAdmin)
        try await repository.createSession(for: section)
        
        return try await repository.getSession(for: userId)
    }

    func deleteSession(for userId: UUID) async throws {
        guard let section = try await repository.getSession(for: userId) else {
            return
        }

        try await repository.deleteSession(for: section)
    }
    
    private func createSessionToken(for userId: UUID) -> SessionToken {
        return SessionToken(userId: userId)
    }
}
