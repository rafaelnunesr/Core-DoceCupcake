import XCTVapor

@testable import App

final class SignUpAdminControllerTests: XCTestCase {
    private var app: Application!
    private var sut: SignUpAdminController!
    private var mockRepository: MockSignUpAdminRepository!
    private var mockSecurity: MockSecurity!
    private var mockDependencyProvider: MockDependencyProvider!
    private var route = PathRoutes.admin.rawValue
    
    override func setUp() async throws {
        app = try await Application.make(.testing)
        mockRepository = MockSignUpAdminRepository()
        mockSecurity = MockSecurity()
        mockDependencyProvider = MockDependencyProvider(app: app, security: mockSecurity)
        sut = SignUpAdminController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        
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
    
    func test_when_request_fields_are_incomplete_should_return_bad_request_error() throws {
        try self.app.test(.POST, route,
        beforeRequest: { request in
            try request.content.encode(invalidRequest)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .badRequest)
        })
    }
    
    func test_when_admin_exists_should_return_conflict_error() throws {
        let expectedResponse = ErrorResponse(error: true, reason: APIErrorMessage.Credentials.userAlreadyRegistered)
        mockRepository.admin = MockAdmin().mary
        
        try self.app.test(.POST, route,
        beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .conflict)
            let bodyResponse = convertBodyToErrorResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_when_credentials_are_invalid_should_return_bad_request_error() throws {
        let expectedResponse = ErrorResponse(error: true, reason: APIErrorMessage.Credentials.invalidCredentials)
        mockSecurity.isValid = false
        
        try self.app.test(.POST, route,
        beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .badRequest)
            let bodyResponse = convertBodyToErrorResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_create_admin_with_valid_data() throws {
        let expectedResponse = GenericMessageResponse(message: SignUpAdminController.Constants.welcomeMessage)
        
        try self.app.test(.POST, route,
                          beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            let bodyResponse = convertBodyToGenericMessageResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
}

extension SignUpAdminControllerTests {
    var invalidRequest: [String: String] {
        ["invalid": "invalid"]
    }
    
    var requestContent: [String: String] {
        ["user_name": "A",
         "email": "B",
         "password": "C"]
    }
}
