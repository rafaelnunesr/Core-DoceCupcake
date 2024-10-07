import Vapor

protocol AddressControllerProtocol: Sendable {
    func fetchAddressById(_ id: UUID) async throws -> Address?
    func fetchAddressByUserId(_ userId: UUID) async throws -> Address?
    func create(_ address: Address) async throws
    func update(_ address: Address) async throws
    func delete(_ addressUuid: UUID) async throws
}

struct AddressController: AddressControllerProtocol {
    private var repository: AddressRepositoryProtocol
    
    init(repository: AddressRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchAddressById(_ id: UUID) async throws -> Address? {
        try await repository.fetchAddressById(id)
    }
    
    func fetchAddressByUserId(_ userId: UUID) async throws -> Address? {
        try await repository.fetchAddressByUserId(userId)
    }
    
    func create(_ address: Address) async throws {
        try await repository.create(address)
    }
    
    func update(_ address: Address) async throws {
        try await repository.update(address)
    }
    
    func delete(_ addressUuid: UUID) async throws {
        guard let address = try await repository.fetchAddressById(addressUuid)
        else { throw APIResponseError.Common.notFound }
        try await repository.delete(address)
    }
}
