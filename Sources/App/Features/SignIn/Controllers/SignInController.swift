import FluentPostgresDriver
import Foundation
import Vapor

struct SignInController: RouteCollection, Sendable {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: SignInRepositoryProtocol
    private let sessionController: SessionControllerProtocol
    private let security: SecurityProtocol

    init(dependencyProvider: DependencyProviderProtocol, 
         repository: SignInRepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
        
        sessionController = dependencyProvider.getSessionController()
        security = dependencyProvider.getSecurityInstance()
    }

    func boot(routes: RoutesBuilder) throws {
        let signInRoutes = routes.grouped(Routes.signin.path)
        signInRoutes.post(use: signIn)
    }

    @Sendable
    private func signIn(req: Request) async throws -> ClientTokenResponse {
        let model: SignInRequest = try convertRequestDataToModel(req: req)
        return try await validateUser(model: model, req: req)
    }
    
    private func validateUser(model: SignInRequest, req: Request) async throws -> ClientTokenResponse {
        if let userId = try await getUserId(model) {
            return try await createSectionForUser(userId: userId, req: req, isAdmin: false)
        }
        
        if let adminId = try await getAdminId(model) {
            return try await createSectionForUser(userId: adminId, req: req, isAdmin: true)
        }
        
        throw Abort(.unauthorized, reason: APIErrorMessage.Credentials.invalidCredentials)
    }
    
    private func getUserId(_ model: SignInRequest) async throws -> UUID? {
        if let user = try await repository.fetchUserByEmail(model.email),
           try security.isHashedValidCorrect(plainValue: model.password, hashValue: user.password) {
            return user.id
        }
        
        return nil
    }
    
    private func getAdminId(_ model: SignInRequest) async throws -> UUID? {
        if let admin = try await repository.fetchAdminByEmail(model.email),
           try security.isHashedValidCorrect(plainValue: model.password, hashValue: admin.password) {
            return admin.id
        }
        
        return nil
    }

    private func createSectionForUser(userId: UUID, req: Request, isAdmin: Bool) async throws -> ClientTokenResponse {
        guard let section = try await sessionController.createSession(for: userId, isAdmin: isAdmin, req: req) else {
            throw Abort(.internalServerError)
        }
        return ClientTokenResponse(token: section.token)
    }
}
