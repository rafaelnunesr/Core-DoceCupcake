import Foundation

@testable import App

final class MockSignUpUserRepository: UserRepositoryProtocol {
    var user: User?

    func fetchUserId(with email: String) async throws -> UUID? {
        user?.id
    }

    func create(with user: User) async throws -> UUID {
        self.user = user
        return user.id ?? UUID()
    }
    
    func fetchUser(with id: UUID) async throws -> User? {
        user
    }
    
    func fetchUser(with email: String) async throws -> User? {
        user
    }
    
    func update(with user: App.User) async throws -> UUID {
        user.id ?? UUID()
    }
}
