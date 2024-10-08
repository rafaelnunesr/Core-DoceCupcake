import XCTVapor

@testable import App

final class ProductTagsControllerTests: XCTestCase {
    private var app: Application!
    private var sut: ProductTagsController!
    private var mockRepository: MockRepository!
    private var mockSecurity: MockSecurity!
    private var mockDependencyProvider: MockDependencyProvider!
    private var route = PathRoutes.productTags.rawValue
    
    override func setUp() async throws {
        app = try await Application.make(.testing)
        mockRepository = MockRepository()
        mockSecurity = MockSecurity()
        mockDependencyProvider = MockDependencyProvider(app: app, security: mockSecurity)
        sut = ProductTagsController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
    }
    
    override func tearDown() async throws {
        try await self.app.asyncShutdown()
        app = nil
        sut = nil
        mockRepository = nil
        mockSecurity = nil
        mockDependencyProvider = nil
    }
    
    func test_get_product_tags_list_should_return_correct_list() throws {
        let expectedTag = MockProductTags().tagA
        mockRepository.result = expectedTag
        sut = ProductTagsController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        
        try sut.boot(routes: app.routes)
        
        try self.app.test(.GET, route, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            
            if let bodyResponse: ProductTagListResponse = try convertRequestDataToModel(with: response.body) {
                XCTAssertEqual(bodyResponse.count, 1)
                guard let tag = bodyResponse.tags.first else {
                    return XCTFail("No tag found in response")
                }
                
                XCTAssertEqual(tag.code, expectedTag.code)
                XCTAssertEqual(tag.description, expectedTag.description)
            } else {
                XCTFail("Failed converting response body to ProductTagListResponse model")
            }
        })
    }
    
    func test_create_tag_when_user_is_not_allowed() throws {
        mockDependencyProvider.adminValidationMiddleware.responseStatus = .unauthorized
        sut = ProductTagsController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        
        try sut.boot(routes: app.routes)
        
        let expectedResponse = ErrorResponse(error: true, reason: .unauthorized)
        
        try self.app.test(.POST, route,
                          beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .unauthorized)
            let bodyResponse = convertBodyToErrorResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_create_tag() throws {
        sut = ProductTagsController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        
        try sut.boot(routes: app.routes)
        
        let expectedResponse = GenericMessageResponse(message: ProductTagsController.Constants.tagCreated)
        
        try self.app.test(.POST, route,
                          beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            let bodyResponse = convertBodyToGenericMessageResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_create_tag_when_already_exists() throws {
        mockRepository.result = MockProductTags().tagA
        sut = ProductTagsController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        
        try sut.boot(routes: app.routes)
        
        let expectedResponse = ErrorResponse(error: true, reason: .conflict)
        
        try self.app.test(.POST, route,
                          beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .conflict)
            let bodyResponse = convertBodyToErrorResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_update_tag_when_user_is_not_allowed() throws {
        mockRepository.result = MockProductTags().tagA
        mockDependencyProvider.adminValidationMiddleware.responseStatus = .unauthorized
        sut = ProductTagsController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        
        try sut.boot(routes: app.routes)
        
        let expectedResponse = ErrorResponse(error: true, reason: .unauthorized)
        
        try self.app.test(.PUT, route,
                          beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .unauthorized)
            let bodyResponse = convertBodyToErrorResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_update_tag_when_does_not_exist() throws {
        sut = ProductTagsController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        
        try sut.boot(routes: app.routes)
        
        let expectedResponse = ErrorResponse(error: true, reason: .notFound)
        
        try self.app.test(.PUT, route,
                          beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .notFound)
            let bodyResponse = convertBodyToErrorResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_update_tag() throws {
        mockRepository.result = MockProductTags().tagA
        sut = ProductTagsController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        
        try sut.boot(routes: app.routes)
        
        let expectedResponse = GenericMessageResponse(message: ProductTagsController.Constants.tagUpdated)
        
        try self.app.test(.PUT, route,
                          beforeRequest: { request in
            try request.content.encode(requestContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            let bodyResponse = convertBodyToGenericMessageResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_delete_tag_when_user_is_not_allowed() throws {
        mockRepository.result = MockProductTags().tagA
        mockDependencyProvider.adminValidationMiddleware.responseStatus = .unauthorized
        sut = ProductTagsController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        
        try sut.boot(routes: app.routes)
        
        let expectedResponse = ErrorResponse(error: true, reason: .unauthorized)
        
        try self.app.test(.DELETE, route,
                          beforeRequest: { request in
            try request.content.encode(deleteContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .unauthorized)
            let bodyResponse = convertBodyToErrorResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_delete_tag_when_tag_does_not_exists() throws {
        sut = ProductTagsController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        
        try sut.boot(routes: app.routes)
        
        let expectedResponse = ErrorResponse(error: true, reason: .notFound)
        
        try self.app.test(.DELETE, route,
                          beforeRequest: { request in
            try request.content.encode(deleteContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .notFound)
            let bodyResponse = convertBodyToErrorResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
    
    func test_delete_tag() throws {
        mockRepository.result = MockProductTags().tagA
        sut = ProductTagsController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
        
        try sut.boot(routes: app.routes)
        
        let expectedResponse = GenericMessageResponse(message: ProductTagsController.Constants.tagDeleted)
        
        try self.app.test(.DELETE, route,
                          beforeRequest: { request in
            try request.content.encode(deleteContent)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            let bodyResponse = convertBodyToGenericMessageResponse(with: response.body)
            XCTAssertEqual(bodyResponse, expectedResponse)
        })
    }
}

extension ProductTagsControllerTests {
    var requestContent: APIProductTag {
        APIProductTag(code: "A", description: "B")
    }
    
    var deleteContent: [String: String] {
        ["id": "A"]
    }
}
