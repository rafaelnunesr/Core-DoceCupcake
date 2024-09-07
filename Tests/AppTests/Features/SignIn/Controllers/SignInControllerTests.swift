import XCTVapor

@testable import App

final class SignInControllerTests: XCTestCase {
    private var app: Application!
    private var sut: SignInController!
    private var mockRepository: MockSignInRepository!
    private var mockSectionController: MockSectionController!
    private var mockSecurity: MockSecurity!
    private var mockDependencyProvider: MockDependencyProvider!
    
    override func setUp() async throws {
        app = try await Application.make(.testing)
        mockRepository = MockSignInRepository()
        mockSectionController = MockSectionController()
        mockSecurity = MockSecurity()
        mockDependencyProvider = MockDependencyProvider(app: app, sectionController: mockSectionController, security: mockSecurity)
        sut = SignInController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        
        try app.register(collection: sut)
    }
    
    override func tearDown() async throws {
        try await self.app.asyncShutdown()
        app = nil
        sut = nil
        mockRepository = nil
        mockSectionController = nil
        mockSecurity = nil
        mockDependencyProvider = nil
    }
    
    func test_signIn_with_invalid_request() throws {
        let expectedResponse = ErrorResponse(error: true, reason: APIErrorMessage.Credentials.invalidCredentials)
        mockSecurity.isValid = false
        
        try self.app.test(.POST, Routes.signin.rawValue,
        beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .unauthorized)
            let bodyResponse = convertBodyToErrorResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_signIn_with_unknown_user() throws {
        let expectedResponse = ErrorResponse(error: true, reason: APIErrorMessage.Credentials.invalidCredentials)
        
        try self.app.test(.POST, Routes.signin.rawValue,
        beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .unauthorized)
            let bodyResponse = convertBodyToErrorResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_signIn_with_valid_user() throws {
        mockRepository.user = MockUser().john
        mockSectionController.section = MockInternalSectionModel().defaultUser
        let expectedResponse = String("{\"token\":\"A\"}")
        
        try self.app.test(.POST, Routes.signin.rawValue,
        beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            XCTAssertEqual(response.body.string, expectedResponse)
        })
    }
    
    func test_signIn_with_valid_admin() throws {
        mockRepository.admin = MockAdmin().mary
        mockSectionController.section = MockInternalSectionModel().adminUser
        let expectedResponse = String("{\"token\":\"A\"}")
        
        try self.app.test(.POST, Routes.signin.rawValue,
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
