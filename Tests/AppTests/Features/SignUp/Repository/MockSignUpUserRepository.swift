import Foundation

@testable import App

final class MockSignUpUserRepository: SignUpUserRepositoryProtocol {
    var user: User?

    func getUserId(with email: String) async throws -> UUID? {
        user?.id
    }

    func createUser(with user: User) async throws {}
}

