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
}
