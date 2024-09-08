import XCTVapor

@testable import App

final class PackagingControllerTests: XCTestCase {
    private var app: Application!
    private var sut: PackagingController!
    private var mockRepository: MockRepository!
    private var mockSecurity: MockSecurity!
    private var mockDependencyProvider: MockDependencyProvider!
    private var route = Routes.packages.rawValue
    
    override func setUp() async throws {
        app = try await Application.make(.testing)
        mockRepository = MockRepository()
        mockSecurity = MockSecurity()
        mockDependencyProvider = MockDependencyProvider(app: app, security: mockSecurity)
        sut = PackagingController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        
        try app.register(collection: sut)
    }
    
    override func tearDown() async throws {
        try await self.app.asyncShutdown()
        app = nil
        sut = nil
        mockRepository = nil
        mockSecurity = nil
        mockDependencyProvider = nil
    }
    
    func test_get_package_list_should_return_correct_values() throws {
        
    }
    
    func test_create_package_when_user_sends_a_request_should_return_unauthorized_error() throws {
        
    }
    
    func test_delete_package_when_user_sends_a_request_should_return_unauthorized_error() throws {
        
    }
    
    func test_create_package_when_admin_tries_to_create_repeated_package_should_return_conflict_error() throws {
        
    }
    
    func test_create_package_when_admin_tries_to_create_new_package_should_succeed() throws {
        
    }
    
    func test_delete_package_when_admin_tries_to_delete_unknowned_package_should_return_not_found_error() throws {
        
    }
    
    func test_delete_package_when_admin_tries_to_delete_package_should_succeed() throws {
        
    }
}
