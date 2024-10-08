import XCTVapor

@testable import App

final class DeliveryControllerTests: XCTestCase {
    private var app: Application!
    private var sut: DeliveryController!
    private var mockSecurity: MockSecurity!
    private var mockDependencyProvider: MockDependencyProvider!
    private var route = PathRoutes.delivery.rawValue
    
    override func setUp() async throws {
        app = try await Application.make(.testing)
        mockSecurity = MockSecurity()
        mockDependencyProvider = MockDependencyProvider(app: app, security: mockSecurity)
        sut = DeliveryController(userSectionValidation: mockDependencyProvider.getUserSessionValidationMiddleware())
    }
    
    override func tearDown() async throws {
        try await self.app.asyncShutdown()
        app = nil
        sut = nil
        mockSecurity = nil
        mockDependencyProvider = nil
    }

    func test_get_delivery_fee_when_user_is_not_logged_in() throws {
        mockDependencyProvider.sessionValidationMiddleware.responseStatus = .unauthorized
        sut = DeliveryController(userSectionValidation: mockDependencyProvider.getUserSessionValidationMiddleware())
        try sut.boot(routes: app.routes)
        
        let expectedResponse = ErrorResponse(error: true, reason: .unauthorized)
        
        try self.app.test(.GET, "\(route)/123", afterResponse: { response in
            XCTAssertEqual(response.status, .unauthorized)
            let bodyResponse = convertBodyToErrorResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_get_delivery_fee_when_user_is_logged_in() throws {
        try sut.boot(routes: app.routes)
        
        try self.app.test(.GET, "\(route)/123", afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            let bodyResponse = try response.content.decode(Double.self)
            XCTAssertEqual(bodyResponse, 9.99)
        })
    }
}
