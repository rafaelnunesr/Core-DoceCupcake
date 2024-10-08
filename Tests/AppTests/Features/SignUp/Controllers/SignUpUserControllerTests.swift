import XCTVapor

@testable import App

final class SignUpUserControllerTests: XCTestCase {
    private var app: Application!
    private var sut: SignUpUserController!
    private var mockRepository: MockSignUpUserRepository!
    private var mockSecurity: MockSecurity!
    private var mockAddressController: MockAddressController!
    private var mockDependencyProvider: MockDependencyProvider!
    let signupModel = MockSignUpUserRequest().user
    
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
        mockRepository.user = MockUser().john
        
        try self.app.test(.POST, PathRoutes.signup.rawValue,
        beforeRequest: { request in
            try request.content.encode(signupModel)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .conflict)
        })
    }
    
    func test_when_credentials_are_invalid_should_return_unauthorized_error() throws {
        mockSecurity.isValid = false
        
        try self.app.test(.POST, PathRoutes.signup.rawValue,
        beforeRequest: { request in
            try request.content.encode(signupModel)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .unauthorized)
        })
    }
    
    func test_create_user_with_valid_data() throws {
        let expectedResponse = GenericMessageResponse(message: "The account for John Smith has been successfully created.")
        mockAddressController.address = MockAddress().addressA
        mockSecurity.isValid = true
        
        sut = SignUpUserController(dependencyProvider: mockDependencyProvider,
                                   repository: mockRepository,
                                   addressController: mockAddressController)
        try sut.boot(routes: app.routes)
        
        try self.app.test(.POST, PathRoutes.signup.rawValue,
                          beforeRequest: { request in
            try request.content.encode(signupModel)
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
}
