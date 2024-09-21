import Foundation

@testable import App

final class MockSignUpAdminRepository: SignUpAdminRepositoryProtocol {
    var admin: Admin?

    func fetchUserId(with email: String) async throws -> UUID? {
        admin?.id
    }

    func create(with admin: Admin) async throws {
        self.admin = admin
    }
}
