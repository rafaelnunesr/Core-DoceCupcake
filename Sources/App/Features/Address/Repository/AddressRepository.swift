import FluentPostgresDriver
import Vapor

protocol AddressRepositoryProtocol: Sendable {
    func fetchAddressById(_ id: UUID) async throws -> Address?
    func fetchAddressByUserId(_ userId: UUID) async throws -> Address?
    func create(_ address: Address) async throws
    func update(_ address: Address) async throws
    func delete(_ address: Address) async throws
}

final class AddressRepository: AddressRepositoryProtocol {
    private let database: Database

    init(database: Database) {
        self.database = database
    }

    func fetchAddressById(_ id: UUID) async throws -> Address? {
        try await Address.query(on: database)
            .filter(\.$id == id)
            .first()
    }
    
    func fetchAddressByUserId(_ userId: UUID) async throws -> Address? {
        try await Address.query(on: database)
            .filter(\.$userId == userId)
            .first()
    }

    func create(_ address: Address) async throws {
        try await address.create(on: database)
    }

    func update(_ address: Address) async throws {
        try await address.update(on: database)
    }
    
    func delete(_ address: Address) async throws {
        try await address.delete(on: database)
    }
}
