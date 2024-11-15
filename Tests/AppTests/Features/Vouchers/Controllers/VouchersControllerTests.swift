import XCTVapor

@testable import App

final class VouchersControllerTests: XCTestCase {
    private var app: Application!
    private var sut: VouchersController!
    private var mockRepository: MockRepository!
    private var mockSessionController: MockSessionController!
    private var mockSecurity: MockSecurity!
    private var mockDependencyProvider: MockDependencyProvider!
    private let route = PathRoutes.vouchers.rawValue
    
    override func setUp() async throws {
        app = try await Application.make(.testing)
        mockRepository = MockRepository()
        mockSessionController = MockSessionController()
        mockSecurity = MockSecurity()
        mockDependencyProvider = MockDependencyProvider(app: app, sessionController: mockSessionController, security: mockSecurity)
        sut = VouchersController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        
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
    
    func test_when_non_admin_tries_to_fetch_vouchers_list_should_return_unauthorized_error() throws {
        mockDependencyProvider.adminValidationMiddleware.responseStatus = .unauthorized
        sut = VouchersController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        try sut.boot(routes: app.routes)
        
        try self.app.test(.GET, "\(route)/all", afterResponse: { response in
            XCTAssertEqual(response.status, .unauthorized)
        })
    }
    
    func test_when_non_admin_tries_to_create_voucher_should_return_unauthorized_error() throws {
        mockDependencyProvider.adminValidationMiddleware.responseStatus = .unauthorized
        sut = VouchersController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        try sut.boot(routes: app.routes)
        
        try self.app.test(.POST, route, 
                          beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .unauthorized)
        })
    }
    
    func test_when_non_admin_tries_to_delete_voucher_should_return_unauthorized_error() throws {
        mockDependencyProvider.adminValidationMiddleware.responseStatus = .unauthorized
        sut = VouchersController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        try sut.boot(routes: app.routes)
        
        try self.app.test(.DELETE, route,
                          beforeRequest: { request in
            try request.content.encode(requestContentWithCode)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .unauthorized)
        })
    }
    
    func test_when_admin_tries_to_fetch_vouchers_list_should_return_correct_list() throws {
        mockRepository.result = MockVoucher().voucherA
        sut = VouchersController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        try sut.boot(routes: app.routes)
        
        try self.app.test(.GET, "\(route)/all",
                          afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            if let bodyResponse: APIVoucherListResponse = try convertRequestDataToModel(with: response.body) {
                XCTAssertEqual(bodyResponse.count, 1)
                XCTAssertNotNil(bodyResponse.vouchers.first?.createdAt)
                XCTAssertNotNil(bodyResponse.vouchers.first?.expiryDate)
                XCTAssertEqual(bodyResponse.vouchers.first?.code, "A")
                XCTAssertEqual(bodyResponse.vouchers.first?.percentageDiscount, 0)
                XCTAssertEqual(bodyResponse.vouchers.first?.monetaryDiscount, 0)
                XCTAssertEqual(bodyResponse.vouchers.first?.availabilityCount, 0)
            } else {
                XCTFail("Failed converting response body to APIVoucherModelList model")
            }
        })
    }
    
    func test_when_admin_tries_to_create_an_already_existing_voucher_should_return_conflict_error() throws {
        mockRepository.result = MockVoucher().voucherA
        sut = VouchersController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        try sut.boot(routes: app.routes)
        
        try self.app.test(.POST, route,
                          beforeRequest: { request in
            try request.content.encode(requestContent, using: encoder)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .conflict)
        })
    }
    
    func test_when_admin_tries_to_create_a_voucher_should_return_generic_message() throws {
        sut = VouchersController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        try sut.boot(routes: app.routes)
        
        let expectedResponse = GenericMessageResponse(message: "The voucher with the code A has been created successfully.")
        
        try self.app.test(.POST, route,
                          beforeRequest: { request in
            try request.content.encode(requestContent, using: encoder)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            let bodyResponse = convertBodyToGenericMessageResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_when_admin_tries_to_delete_a_non_existing_voucher_should_return_not_found_error() throws {
        sut = VouchersController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        try sut.boot(routes: app.routes)
     
        try self.app.test(.DELETE, route,
                          beforeRequest: { request in
            try request.content.encode(requestContentWithCode)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .notFound)
        })
    }
    
    func test_when_admin_tries_to_delete_a_voucher_should_return_generic_message() throws {
        mockRepository.result = MockVoucher().voucherA
        sut = VouchersController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        try sut.boot(routes: app.routes)
        
        let expectedResponse = GenericMessageResponse(message: "The voucher with the code A has been deleted successfully.")
        
        try self.app.test(.DELETE, route,
                          beforeRequest: { request in
            try request.content.encode(requestContentWithCode)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            let bodyResponse = convertBodyToGenericMessageResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
}

extension VouchersControllerTests {
    var requestContent: APIVoucher {
        APIVoucher(
            createdAt: Date(),
            expiryDate: Date(),
            code: "A",
            percentageDiscount: 10.0,
            monetaryDiscount: 0.0,
            availabilityCount: 1)
    }
    
    var requestContentWithCode: [String: String] {
        ["code": "A"]
    }
    
    var voucherList: APIVoucherListResponse {
        APIVoucherListResponse(count: 0, vouchers: [])
    }
    
    var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}
