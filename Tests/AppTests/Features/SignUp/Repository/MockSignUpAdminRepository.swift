import Foundation

@testable import App

final class MockSignUpAdminRepository: SignUpAdminRepositoryProtocol {
    var admin: Admin?

    func getUserId(with email: String) async throws -> UUID? {
        admin?.id
    }

    func createUser(with user: Admin) async throws {}
}
