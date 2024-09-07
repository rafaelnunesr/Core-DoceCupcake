@testable import App

final class MockSignInRepository: SignInRepositoryProtocol {
    var user: User?
    var admin: Admin?

    func fetchUserByEmail(_ email: String) async throws -> User? {
        user
    }

    func fetchAdminByEmail(_ email: String) async throws -> Admin? {
        admin
    }
}
