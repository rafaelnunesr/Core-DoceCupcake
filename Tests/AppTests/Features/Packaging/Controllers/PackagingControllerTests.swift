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
        mockRepository.result = MockPackaging().packageA
        sut = PackagingController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        try sut.boot(routes: app.routes)
        
        try self.app.test(.GET, route, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            if let bodyResponse: APIPackageList = try convertRequestDataToModel(with: response.body) {
                XCTAssertEqual(bodyResponse.count, 1)
                XCTAssertNotNil(bodyResponse.package.first?.createdAt)
                XCTAssertEqual(bodyResponse.package.first?.code, "A")
                XCTAssertEqual(bodyResponse.package.first?.description, "description")
                XCTAssertEqual(bodyResponse.package.first?.width, 0)
                XCTAssertEqual(bodyResponse.package.first?.height, 0)
                XCTAssertEqual(bodyResponse.package.first?.depth, 0)
                XCTAssertEqual(bodyResponse.package.first?.price, 0)
                XCTAssertEqual(bodyResponse.package.first?.stockCount, 0)
            } else {
                XCTFail("Failed converting response body to APIVoucherModelList model")
            }
        })
    }
    
    func test_create_package_when_unauthorized_user_sends_a_request_should_return_unauthorized_error() throws {
        mockDependencyProvider.adminValidationMiddleware.responseStatus = .unauthorized
        sut = PackagingController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        try sut.boot(routes: app.routes)
        
        let expectedResponse = ErrorResponse(error: true, reason: APIErrorMessage.Common.unauthorized)
        
        try self.app.test(.POST, route, beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .unauthorized)
            let bodyResponse = convertBodyToErrorResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_delete_package_when_unauthorized_user_sends_a_request_should_return_unauthorized_error() throws {
        mockDependencyProvider.adminValidationMiddleware.responseStatus = .unauthorized
        sut = PackagingController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        try sut.boot(routes: app.routes)
        
        let expectedResponse = ErrorResponse(error: true, reason: APIErrorMessage.Common.unauthorized)
        
        try self.app.test(.DELETE, route, beforeRequest: { request in
            try request.content.encode(deleteContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .unauthorized)
            let bodyResponse = convertBodyToErrorResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_create_package_when_admin_tries_to_create_repeated_package_should_return_conflict_error() throws {
        mockRepository.result = MockPackaging().packageA
        sut = PackagingController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        try sut.boot(routes: app.routes)
        
        let expectedResponse = ErrorResponse(error: true, reason: APIErrorMessage.Common.conflict)
        
        try self.app.test(.POST, route, beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .conflict)
            let bodyResponse = convertBodyToErrorResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_create_package_when_admin_tries_to_create_new_package_should_succeed() throws {
        sut = PackagingController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        try sut.boot(routes: app.routes)
        
        let expectedResponse = GenericMessageResponse(message: "Package created.")
        
        try self.app.test(.POST, route, beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            let bodyResponse = convertBodyToGenericMessageResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_delete_package_when_admin_tries_to_delete_unknowned_package_should_return_not_found_error() throws {
        sut = PackagingController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        try sut.boot(routes: app.routes)
        
        let expectedResponse = ErrorResponse(error: true, reason: APIErrorMessage.Common.notFound)
        
        try self.app.test(.DELETE, route, beforeRequest: { request in
            try request.content.encode(deleteContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .notFound)
            let bodyResponse = convertBodyToErrorResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_delete_package_when_admin_tries_to_delete_package_should_succeed() throws {
        mockRepository.result = MockPackaging().packageA
        sut = PackagingController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        try sut.boot(routes: app.routes)
        
        let expectedResponse = GenericMessageResponse(message: "Package deleted.")
        
        try self.app.test(.DELETE, route, beforeRequest: { request in
            try request.content.encode(deleteContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            let bodyResponse = convertBodyToGenericMessageResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
}

extension PackagingControllerTests {
    var requestContent: APIPackage {
        APIPackage(code: "A",
                   name: .empty,
                   description: .empty,
                   width: 0,
                   height: 0,
                   depth: 0,
                   price: 0,
                   stockCount: 0)
    }
    
    var deleteContent: [String: String] {
        ["id": "A"]
    }
}
