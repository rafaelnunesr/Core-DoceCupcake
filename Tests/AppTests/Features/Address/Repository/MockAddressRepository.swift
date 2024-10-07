import Foundation

@testable import App

final class MockAdressRepository: AddressRepositoryProtocol {
    var result: Address?
    
    func fetchAddressById(_ id: UUID) async throws -> Address? {
        return result
    }

    func fetchAddressByUserId(_ userId: UUID) async throws -> Address? {
        return result
    }
    
    func create(_ address: Address) async throws {
        result = address
    }
    
    func update(_ address: Address) async throws {
        result = address
    }

    func delete(_ address: Address) async throws {
        result = nil
    }
}

