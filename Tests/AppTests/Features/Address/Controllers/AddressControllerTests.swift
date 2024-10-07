import XCTVapor

@testable import App

final class AddressControllerTests: XCTestCase {
    private var app: Application!
    private var sut: AddressController!
    private var mockRepository: MockAdressRepository!
    private var mockSecurity: MockSecurity!
    private var mockDependencyProvider: MockDependencyProvider!
    
    override func setUp() async throws {
        app = try await Application.make(.testing)
        mockRepository = MockAdressRepository()
        mockSecurity = MockSecurity()
        mockDependencyProvider = MockDependencyProvider(app: app, security: mockSecurity)
        sut = AddressController(repository: mockRepository)
    }
    
    override func tearDown() async throws {
        try await self.app.asyncShutdown()
        app = nil
        sut = nil
        mockRepository = nil
        mockSecurity = nil
        mockDependencyProvider = nil
    }
    
    func test_fetch_address_by_id() async throws {
        let address = MockAddress().addressA
        mockRepository.result = address
        let result = try await sut.fetchAddressById(address.id!)
        XCTAssertEqual(result?.id, address.id)
    }
    
    func test_fetch_address_by_user_id() async throws {
        let address = MockAddress().addressA
        mockRepository.result = address
        let result = try await sut.fetchAddressByUserId(address.userId)
        XCTAssertEqual(result?.id, address.id)
    }
    
    func test_create_address() async throws {
        let address = MockAddress().addressA
        try await sut.create(address)
        XCTAssertEqual(mockRepository.result?.id, address.id)
    }
    
    func test_update_address() async throws {
        mockRepository.result = MockAddress().addressA
        let newAddress = MockAddress().addressB
        try await sut.update(newAddress)
        XCTAssertEqual(mockRepository.result?.id, newAddress.id)
    }
    
    func test_delete_address() async throws {
        let address = MockAddress().addressA
        mockRepository.result = address
        try await sut.delete(address.id!)
        XCTAssertNil(mockRepository.result)
    }
}
