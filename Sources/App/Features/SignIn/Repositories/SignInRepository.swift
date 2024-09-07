import FluentPostgresDriver
import Vapor

protocol SignInRepositoryProtocol: Sendable {
    func fetchUserByEmail(_ email: String) async throws -> User?
    func fetchAdminByEmail(_ email: String) async throws -> Admin?
}

final class SignInRepository: SignInRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }
    
    func fetchUserByEmail(_ email: String) async throws -> User? {
        try await User.query(on: database)
            .filter(\.$email == email)
            .first()
    }
    
    func fetchAdminByEmail(_ email: String) async throws -> Admin? {
        try await Admin.query(on: database)
            .filter(\.$email == email)
            .first()
    }
}
