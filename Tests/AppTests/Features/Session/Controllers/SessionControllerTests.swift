import XCTVapor

@testable import App

final class SessionControllerTests: XCTestCase {
    private var app: Application!
    private var sut: SessionController!
    private var mockRepository: MockSessionRepository!
    private var mockSecurity: MockSecurity!
    private var mockDependencyProvider: MockDependencyProvider!
    
    override func setUp() async throws {
        app = try await Application.make(.testing)
        mockRepository = MockSessionRepository()
        mockSecurity = MockSecurity()
        mockDependencyProvider = MockDependencyProvider(app: app, security: mockSecurity)
        sut = SessionController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
    }
    
    override func tearDown() async throws {
        try await self.app.asyncShutdown()
        app = nil
        sut = nil
        mockRepository = nil
        mockSecurity = nil
        mockDependencyProvider = nil
    }
    
    func test_validate_session_when_session_does_not_exists_should_return_unowned() throws {
    }
    
    func test_validate_session_when_session_is_from_user_should_return_user() throws {
        
    }
    
    func test_validate_session_when_session_is_from_admin_should_return_admin() throws {
        
    }
    
    func test_create_session_when_request_is_from_user() throws {
        
    }
    
    func test_create_session() throws {
        
    }
}
