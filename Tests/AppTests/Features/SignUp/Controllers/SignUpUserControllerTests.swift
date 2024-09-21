import XCTVapor

@testable import App

final class SignUpUserControllerTests: XCTestCase {
    private var app: Application!
    private var sut: SignUpUserController!
    private var mockRepository: MockSignUpUserRepository!
    private var mockSecurity: MockSecurity!
    private var mockAddressController: MockAddressController!
    private var mockDependencyProvider: MockDependencyProvider!
    
    override func setUp() async throws {
        app = try await Application.make(.testing)
        mockRepository = MockSignUpUserRepository()
        mockSecurity = MockSecurity()
        mockAddressController = MockAddressController()
        mockDependencyProvider = MockDependencyProvider(app: app, security: mockSecurity)
        sut = SignUpUserController(dependencyProvider: mockDependencyProvider, repository: mockRepository, addressController: mockAddressController)
        
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
        try self.app.test(.POST, PathRoutes.signup.rawValue,
        beforeRequest: { request in
            try request.content.encode(invalidRequest)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .badRequest)
        })
    }
    
    func test_when_user_exists_should_return_conflict_error() throws {
        let expectedResponse = ErrorResponse(error: true, reason: .empty)
        mockRepository.user = MockUser().john
        
        try self.app.test(.POST, PathRoutes.signup.rawValue,
        beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .conflict)
            let bodyResponse = convertBodyToErrorResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_when_credentials_are_invalid_should_return_bad_request_error() throws {
        let expectedResponse = ErrorResponse(error: true, reason: .empty)
        mockSecurity.isValid = false
        
        try self.app.test(.POST, PathRoutes.signup.rawValue,
        beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .badRequest)
            let bodyResponse = convertBodyToErrorResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_create_user_with_valid_data() throws {
        let expectedResponse = GenericMessageResponse(message: .empty)
        
        try self.app.test(.POST, PathRoutes.signup.rawValue,
                          beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            let bodyResponse = convertBodyToGenericMessageResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
}

extension SignUpUserControllerTests {
    var invalidRequest: [String: String] {
        ["invalid": "invalid"]
    }
    
    var requestContent: [String: String] {
        ["user_name": "A",
         "email": "B",
         "password": "C",
         "state": "D",
         "city": "E",
         "address": "F",
         "address_complement": "G"]
    }
}
