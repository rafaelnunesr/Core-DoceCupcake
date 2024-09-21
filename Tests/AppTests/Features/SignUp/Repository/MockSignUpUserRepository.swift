import Foundation

@testable import App

final class MockSignUpUserRepository: SignUpUserRepositoryProtocol {
    var user: User?

    func fetchUserId(with email: String) async throws -> UUID? {
        user?.id
    }

    func create(with user: User) async throws -> UUID {
        self.user = user
        return try user.requireID()
    }
}
