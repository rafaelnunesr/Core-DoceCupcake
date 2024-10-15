import Vapor

protocol AddressControllerProtocol: RouteCollection, Sendable {
    func fetchAddressById(_ id: UUID) async throws -> Address?
    func fetchAddressByUserId(_ userId: UUID) async throws -> Address?
    func create(_ address: Address) async throws
    func update(_ address: Address) async throws
    func delete(_ addressUuid: UUID) async throws
}

struct AddressController: AddressControllerProtocol {
    private var repository: AddressRepositoryProtocol
    
    private let sessionValidation: SessionValidationMiddlewareProtocol
    private let sessionController: SessionControllerProtocol
    
    init(repository: AddressRepositoryProtocol,
         sessionValidation: SessionValidationMiddlewareProtocol,
         sessionController: SessionControllerProtocol) {
        self.repository = repository
        self.sessionValidation = sessionValidation
        self.sessionController = sessionController
    }
    
    func boot(routes: RoutesBuilder) throws {
        let addressRoutes = routes.grouped(PathRoutes.address.path)

        addressRoutes
            .grouped(sessionValidation)
            .get(use: fetchAddress)
    }
    
    @Sendable
    private func fetchAddress(req: Request) async throws -> APIAddress {
        let userId = try await sessionController.fetchLoggedUserId(req: req)
        guard let address = try await fetchAddressByUserId(userId)
        else { throw APIResponseError.Common.internalServerError }
        return APIAddress(from: address)
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
