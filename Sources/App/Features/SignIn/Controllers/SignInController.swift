import FluentPostgresDriver
import Foundation
import Vapor

struct SignInController: RouteCollection {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: SignInRepositoryProtocol
    private let sectionController: SectionControllerProtocol
    private let security: SecurityProtocol

    init(dependencyProvider: DependencyProviderProtocol, 
         repository: SignInRepositoryProtocol,
         sectionController: SectionController) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
        self.sectionController = sectionController
        
        security = dependencyProvider.getSecurityInstance()
    }

    func boot(routes: RoutesBuilder) throws {
        let signInRoutes = routes.grouped("signIn")
        signInRoutes.post(use: signIn)
    }

    func signIn(req: Request) async throws -> ClientTokenResponse {
        let model: APISignInModel = try convertRequestDataToModel(req: req)
        return try await validateUser(model: model, req: req)
    }
    
    private func validateUser(model: APISignInModel, req: Request) async throws -> ClientTokenResponse {
        if let userId = try await getUserId(model) {
            return try await createSectionForUser(userId: userId, req: req, isAdmin: false)
        }
        
        if let managerId = try await getManagerId(model) {
            return try await createSectionForUser(userId: managerId, req: req, isAdmin: true)
        }
        
        throw Abort(.unauthorized, reason: APIErrorMessage.Credentials.invalidCredentials)
    }
    
    private func getUserId(_ model: APISignInModel) async throws -> UUID? {
        if let user = try await repository.fetchUserByEmail(model.email) {
            guard try security.isHashedValidCorrect(plainValue: model.password, hashValue: user.password) else {
                return nil
            }
            
            return user.id
        }
        
        return nil
    }
    
    private func getManagerId(_ model: APISignInModel) async throws -> UUID? {
        if let manager = try await repository.fetchManagerByEmail(model.email) {
            guard try security.isHashedValidCorrect(plainValue: model.password, hashValue: manager.password) else {
                return nil
            }
            
            return manager.id
        }
        
        return nil
    }

    private func createSectionForUser(userId: UUID, req: Request, isAdmin: Bool) async throws -> ClientTokenResponse {
        guard let section = try await sectionController.createSection(for: userId, isAdmin: isAdmin, req: req) else {
            throw Abort(.internalServerError)
        }
        return ClientTokenResponse(token: section.token)
    }
}
