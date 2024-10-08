import XCTVapor

@testable import App

final class SignInControllerTests: XCTestCase {
    private var app: Application!
    private var sut: SignInController!
    private var mockRepository: MockSignInRepository!
    private var mockSessionController: MockSessionController!
    private var mockSecurity: MockSecurity!
    private var mockDependencyProvider: MockDependencyProvider!
    
    override func setUp() async throws {
        app = try await Application.make(.testing)
        mockRepository = MockSignInRepository()
        mockSessionController = MockSessionController()
        mockSecurity = MockSecurity()
        mockDependencyProvider = MockDependencyProvider(app: app, sessionController: mockSessionController, security: mockSecurity)
        sut = SignInController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        
        try app.register(collection: sut)
    }
    
    override func tearDown() async throws {
        try await self.app.asyncShutdown()
        app = nil
        sut = nil
        mockRepository = nil
        mockSessionController = nil
        mockSecurity = nil
        mockDependencyProvider = nil
    }
    
    func test_signIn_with_invalid_request() throws {
        mockSecurity.isValid = false

        try self.app.test(.POST, PathRoutes.signin.rawValue,
        beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .unauthorized)
        })
    }
    
    func test_signIn_with_unknown_user() throws {
        try self.app.test(.POST, PathRoutes.signin.rawValue,
        beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .unauthorized)
        })
    }
    
    func test_signIn_with_valid_user() throws {
        mockRepository.user = MockUser().john
        mockSessionController.session = MockInternalSessionModel().defaultUser
        let expectedResponse = String("{\"token\":\"A\"}")
        
        try self.app.test(.POST, PathRoutes.signin.rawValue,
        beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            XCTAssertEqual(response.body.string, expectedResponse)
        })
    }
    
    func test_signIn_with_valid_admin() throws {
        mockRepository.admin = MockAdmin().mary
        mockSessionController.session = MockInternalSessionModel().adminUser
        let expectedResponse = String("{\"token\":\"A\"}")
        
        try self.app.test(.POST, PathRoutes.signin.rawValue,
        beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            XCTAssertEqual(response.body.string, expectedResponse)
        })
    }
}

extension SignInControllerTests {
    var requestContent: [String: String] {
        ["email": "A", "password": "B"]
    }
}
