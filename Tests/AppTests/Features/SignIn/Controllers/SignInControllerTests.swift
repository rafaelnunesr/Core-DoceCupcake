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
    
    func test_signIn_with_invalid_email() throws {
        let expectedResponse = ErrorResponse(error: true, reason: APIErrorMessage.Credentials.invalidCredentials)
        
        try self.app.test(.POST, Routes.signin.rawValue,
        beforeRequest: { request in
            try request.content.encode(invalidEmailRequest)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .unauthorized)
            let bodyResponse = convertBodyToErrorResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_signIn_with_invalid_password() throws {
        let expectedResponse = ErrorResponse(error: true, reason: APIErrorMessage.Credentials.invalidCredentials)
        
        try self.app.test(.POST, Routes.signin.rawValue,
        beforeRequest: { request in
            try request.content.encode(invalidPasswordRequest)
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
            try request.content.encode(validRequest)
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
            try request.content.encode(validRequest)
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
            try request.content.encode(validRequest)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            XCTAssertEqual(response.body.string, expectedResponse)
        })
    }
}

extension SignInControllerTests {
    var invalidEmailRequest: [String: String] {
        ["email": "invalid.com", "password": "Aa12345678#"]
    }
    
    var invalidPasswordRequest: [String: String] {
        ["email": "email@email.com", "password": "123#"]
    }
    
    var validRequest: [String: String] {
        ["email": "email@email.com", "password": "Aa12345678#"]
    }
    
    func convertBodyToErrorResponse(with body: ByteBuffer) -> ErrorResponse {
        let data = Data(buffer: body)
        let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
        return errorResponse ?? ErrorResponse(error: false, reason: .empty)
    }
}
