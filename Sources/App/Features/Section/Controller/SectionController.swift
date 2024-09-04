import FluentPostgresDriver
import Foundation
import Vapor

enum SectionControlAccess {
    case user
    case admin
    case unowned
}

protocol SectionControllerProtocol {
    func validateSection(req: Request) async throws -> SectionControlAccess
    func createSection(for userId: UUID, isAdmin: Bool, req: Request) async throws -> InternalSectionModel? // improve this
    func deleteSection(for userId: UUID) async throws
}

struct SectionController: SectionControllerProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: SectionRepositoryProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: SectionRepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
    }

    func validateSection(req: Request) async throws -> SectionControlAccess {
        let payload = try await req.jwt.verify(as: SessionToken.self)
        let user = try await repository.getSection(for: payload.userId)
        
        guard let user else {
            return .unowned
        }
        
        return user.isAdmin ? .admin : .user
    }

    func createSection(for userId: UUID, isAdmin: Bool, req: Request) async throws -> InternalSectionModel? {
        try await deleteSection(for: userId)
        
        let sectionToken = createSectionToken(for: userId)
        let token = try await req.jwt.sign(sectionToken)
        let section = InternalSectionModel(expiryDate: sectionToken.expiration.value, userId: sectionToken.userId, token: token, isAdmin: isAdmin)
        try await repository.createSection(for: section)
        
        return try await repository.getSection(for: userId)
    }

    func deleteSection(for userId: UUID) async throws {
        guard let section = try await repository.getSection(for: userId) else {
            return
        }

        try await repository.deleteSection(for: section)
    }
    
    private func createSectionToken(for userId: UUID) -> SessionToken {
        return SessionToken(userId: userId)
    }
}
