import Foundation
import Vapor

@testable import App

struct MockAddressController: AddressControllerProtocol {
    var address: Address?
    
    func boot(routes: RoutesBuilder) throws {}
    
    func fetchAddressById(_ id: UUID) async throws -> Address? {
        address
    }
    
    func fetchAddressByUserId(_ userId: UUID) async throws -> Address? {
        address
    }
    
    func create(_ address: Address) async throws {}
    func update(_ address: Address) async throws {}
    func delete(_ addressUuid: UUID) async throws {}
}
