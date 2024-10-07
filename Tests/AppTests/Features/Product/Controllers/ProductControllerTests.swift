//import XCTVapor
//
//@testable import App
//
//final class ProductControllerTests: XCTestCase {
//    private var app: Application!
//    private var sut: ProductController!
//    private var mockRepository: MockProductRepository!
//    private var mockTagsController: MockProductTagsController!
//    private var mockNutritionalController: MockNutritionalController!
//    private var mockSecurity: MockSecurity!
//    private var mockDependencyProvider: MockDependencyProvider!
//    private var route = PathRoutes.products.rawValue
//    
//    override func setUp() async throws {
//        app = try await Application.make(.testing)
//        mockRepository = MockProductRepository()
//        mockTagsController = MockProductTagsController()
//        mockNutritionalController = MockNutritionalController()
//        mockSecurity = MockSecurity()
//        mockDependencyProvider = MockDependencyProvider(app: app, security: mockSecurity)
//        sut = ProductController(dependencyProvider: mockDependencyProvider,
//                                productRepository: mockRepository,
//                                tagsController: mockTagsController,
//                                nutritionalController: mockNutritionalController)
//    }
//    
//    override func tearDown() async throws {
//        try await self.app.asyncShutdown()
//        app = nil
//        sut = nil
//        mockRepository = nil
//        mockTagsController = nil
//        mockNutritionalController = nil
//        mockSecurity = nil
//        mockDependencyProvider = nil
//    }
//    
//    func test_get_product_list_should_return_correct_product_list() throws {
//        let expectedProduct = MockProduct().productA
//        let expectedTag = MockProductTags().tagA
//        let expectedNutritional = MockNutritionalInformation().infoA
//        
//        mockRepository.result = expectedProduct
//        mockTagsController.productTag = expectedTag
//        mockNutritionalController.information = expectedNutritional
//        sut = ProductController(dependencyProvider: mockDependencyProvider,
//                                productRepository: mockRepository,
//                                tagsController: mockTagsController,
//                                nutritionalController: mockNutritionalController)
//        try sut.boot(routes: app.routes)
//        
//        try self.app.test(.GET, route, afterResponse: { response in
//            XCTAssertEqual(response.status, .ok)
//            
//            if let bodyResponse: ProductListResponse = try convertRequestDataToModel(with: response.body) {
//                XCTAssertEqual(bodyResponse.count, 1)
//                guard let product = bodyResponse.products.first else {
//                    return XCTFail("No product found in response")
//                }
//                
//                validateProduct(product, with: expectedProduct)
//                validateTags(product.tags, with: expectedTag)
//                validateTags(product.allergicTags, with: expectedTag)
//                validateNutritionalInfo(product.nutritionalInformations, with: expectedNutritional)
//                XCTAssertTrue(product.isNew)
//            } else {
//                XCTFail("Failed converting response body to ProductListResponse model")
//            }
//        })
//    }
//
//    func test_get_product_with_invalid_product_code_should_return_not_found_error() throws {
//        sut = ProductController(dependencyProvider: mockDependencyProvider,
//                                productRepository: mockRepository,
//                                tagsController: mockTagsController,
//                                nutritionalController: mockNutritionalController)
//        try sut.boot(routes: app.routes)
//        
//        try self.app.test(.GET, "\(route)/123", afterResponse: { response in
//            XCTAssertEqual(response.status, .notFound)
//            let bodyResponse = convertBodyToErrorResponse(with: response.body)
//            XCTAssertEqual(bodyResponse, ErrorResponseHelper.notFound)
//        })
//    }
//    
//    func test_get_product_with_valid_product_code_should_return_correct_product() throws {
//        let expectedProduct = MockProduct().productA
//        let expectedTag = MockProductTags().tagA
//        let expectedNutritional = MockNutritionalInformation().infoA
//        
//        mockRepository.result = expectedProduct
//        mockTagsController.productTag = expectedTag
//        mockNutritionalController.information = expectedNutritional
//        sut = ProductController(dependencyProvider: mockDependencyProvider,
//                                productRepository: mockRepository,
//                                tagsController: mockTagsController,
//                                nutritionalController: mockNutritionalController)
//        try sut.boot(routes: app.routes)
//        
//        try self.app.test(.GET, "\(route)/\(expectedProduct.code)", afterResponse: { response in
//            XCTAssertEqual(response.status, .ok)
//            
//            if let product: APIProductResponse = try convertRequestDataToModel(with: response.body) {
//                validateProduct(product, with: expectedProduct)
//                validateTags(product.tags, with: expectedTag)
//                validateTags(product.allergicTags, with: expectedTag)
//                validateNutritionalInfo(product.nutritionalInformations, with: expectedNutritional)
//                XCTAssertTrue(product.isNew)
//            } else {
//                XCTFail("Failed converting response body to ProductListResponse model")
//            }
//        })
//    }
//    
//    func test_create_new_product_when_non_admin_should_return_unauthorized_error() throws {
//        mockDependencyProvider.adminValidationMiddleware.responseStatus = .unauthorized
//        sut = ProductController(dependencyProvider: mockDependencyProvider,
//                                productRepository: mockRepository,
//                                tagsController: mockTagsController,
//                                nutritionalController: mockNutritionalController)
//        try sut.boot(routes: app.routes)
//        
//        let expectedResponse = ErrorResponse(error: true, reason: .empty)
//        
//        try self.app.test(.POST, route,
//                          beforeRequest: { request in
//            try request.content.encode(requestContent)
//        }, afterResponse: { response in
//            XCTAssertEqual(response.status, .unauthorized)
//            let bodyResponse = convertBodyToErrorResponse(with: response.body)
//            XCTAssertEqual(bodyResponse, expectedResponse)
//        })
//    }
//    
//    func test_update_product_when_non_admin_should_return_unauthorized_error() throws {
//        mockDependencyProvider.adminValidationMiddleware.responseStatus = .unauthorized
//        sut = ProductController(dependencyProvider: mockDependencyProvider,
//                                productRepository: mockRepository,
//                                tagsController: mockTagsController,
//                                nutritionalController: mockNutritionalController)
//        try sut.boot(routes: app.routes)
//        
//        let expectedResponse = ErrorResponse(error: true, reason: .empty)
//        
//        try self.app.test(.PUT, route,
//                          beforeRequest: { request in
//            try request.content.encode(requestContent)
//        }, afterResponse: { response in
//            XCTAssertEqual(response.status, .unauthorized)
//            let bodyResponse = convertBodyToErrorResponse(with: response.body)
//            XCTAssertEqual(bodyResponse, expectedResponse)
//        })
//    }
//    
//    func test_delete_product_when_non_admin_should_return_unauthorized_error() throws {
//        mockDependencyProvider.adminValidationMiddleware.responseStatus = .unauthorized
//        sut = ProductController(dependencyProvider: mockDependencyProvider,
//                                productRepository: mockRepository,
//                                tagsController: mockTagsController,
//                                nutritionalController: mockNutritionalController)
//        try sut.boot(routes: app.routes)
//        
//        let expectedResponse = ErrorResponse(error: true, reason: .empty)
//        
//        try self.app.test(.DELETE, route,
//                          beforeRequest: { request in
//            try request.content.encode(deleteContent)
//        }, afterResponse: { response in
//            XCTAssertEqual(response.status, .unauthorized)
//            let bodyResponse = convertBodyToErrorResponse(with: response.body)
//            XCTAssertEqual(bodyResponse, expectedResponse)
//        })
//    }
//    
//    func test_create_new_product_with_repeated_model() throws {
//        mockRepository.result = MockProduct().productA
//        mockTagsController.productTag = MockProductTags().tagA
//        mockNutritionalController.information = MockNutritionalInformation().infoA
//        sut = ProductController(dependencyProvider: mockDependencyProvider,
//                                productRepository: mockRepository,
//                                tagsController: mockTagsController,
//                                nutritionalController: mockNutritionalController)
//        try sut.boot(routes: app.routes)
//        
//        try self.app.test(.POST, route,
//                          beforeRequest: { request in
//            try request.content.encode(requestContent)
//        }, afterResponse: { response in
//            XCTAssertEqual(response.status, .conflict)
//            let bodyResponse = convertBodyToErrorResponse(with: response.body)
//            XCTAssertEqual(bodyResponse, ErrorResponseHelper.conflictError)
//        })
//    }
//    
//    func test_create_new_product() throws {
//        mockDependencyProvider.adminValidationMiddleware.responseStatus = .success
//        mockTagsController.productTag = MockProductTags().tagA
//        mockTagsController.areTagsValid = true
//        sut = ProductController(dependencyProvider: mockDependencyProvider,
//                                productRepository: mockRepository,
//                                tagsController: mockTagsController,
//                                nutritionalController: mockNutritionalController)
//        try sut.boot(routes: app.routes)
//        
//        let expectedResponse = GenericMessageResponse(message: ProductController.Constants.productCreated)
//        
//        try self.app.test(.POST, route,
//                          beforeRequest: { request in
//            try request.content.encode(requestContent)
//        }, afterResponse: { response in
//            XCTAssertEqual(response.status, .ok)
//            let bodyResponse = convertBodyToGenericMessageResponse(with: response.body)
//            XCTAssertEqual(bodyResponse, expectedResponse)
//        })
//    }
//    
//    func test_update_non_existing_product() throws {
//        mockDependencyProvider.adminValidationMiddleware.responseStatus = .success
//        mockTagsController.areTagsValid = true
//        sut = ProductController(dependencyProvider: mockDependencyProvider,
//                                productRepository: mockRepository,
//                                tagsController: mockTagsController,
//                                nutritionalController: mockNutritionalController)
//        try sut.boot(routes: app.routes)
//        
//        try self.app.test(.PUT, route,
//                          beforeRequest: { request in
//            try request.content.encode(requestContent)
//        }, afterResponse: { response in
//            XCTAssertEqual(response.status, .notFound)
//            let bodyResponse = convertBodyToErrorResponse(with: response.body)
//            XCTAssertEqual(bodyResponse, ErrorResponseHelper.notFound)
//        })
//    }
//    
//    func test_update_product() throws {
//        mockDependencyProvider.adminValidationMiddleware.responseStatus = .success
//        mockRepository.result = MockProduct().productA
//        mockTagsController.productTag = MockProductTags().tagA
//        mockTagsController.areTagsValid = true
//        sut = ProductController(dependencyProvider: mockDependencyProvider,
//                                productRepository: mockRepository,
//                                tagsController: mockTagsController,
//                                nutritionalController: mockNutritionalController)
//        try sut.boot(routes: app.routes)
//        
//        let expectedResponse = GenericMessageResponse(message: ProductController.Constants.productUpdated)
//        
//        try self.app.test(.PUT, route,
//                          beforeRequest: { request in
//            try request.content.encode(requestContent)
//        }, afterResponse: { response in
//            XCTAssertEqual(response.status, .ok)
//            let bodyResponse = convertBodyToGenericMessageResponse(with: response.body)
//            XCTAssertEqual(bodyResponse, expectedResponse)
//        })
//    }
//    
//    func test_delete_non_existing_product() throws {
//        mockDependencyProvider.adminValidationMiddleware.responseStatus = .success
//        sut = ProductController(dependencyProvider: mockDependencyProvider,
//                                productRepository: mockRepository,
//                                tagsController: mockTagsController,
//                                nutritionalController: mockNutritionalController)
//        try sut.boot(routes: app.routes)
//        
//        let expectedResponse = ErrorResponse(error: true, reason: .empty)
//        
//        try self.app.test(.DELETE, route,
//                          beforeRequest: { request in
//            try request.content.encode(deleteContent)
//        }, afterResponse: { response in
//            XCTAssertEqual(response.status, .notFound)
//            let bodyResponse = convertBodyToErrorResponse(with: response.body)
//            XCTAssertEqual(bodyResponse, expectedResponse)
//        })
//    }
//    
//    func test_delete_product() throws {
//        mockDependencyProvider.adminValidationMiddleware.responseStatus = .success
//        mockRepository.result = MockProduct().productA
//        sut = ProductController(dependencyProvider: mockDependencyProvider,
//                                productRepository: mockRepository,
//                                tagsController: mockTagsController,
//                                nutritionalController: mockNutritionalController)
//        try sut.boot(routes: app.routes)
//        
//        let expectedResponse = GenericMessageResponse(message: ProductController.Constants.productDeleted)
//        
//        try self.app.test(.DELETE, route,
//                          beforeRequest: { request in
//            try request.content.encode(deleteContent)
//        }, afterResponse: { response in
//            XCTAssertEqual(response.status, .ok)
//            let bodyResponse = convertBodyToGenericMessageResponse(with: response.body)
//            XCTAssertEqual(bodyResponse, expectedResponse)
//        })
//    }
//}
//
//extension ProductControllerTests {
//    var requestContent: APIProduct {
//        APIProduct(code: "A", 
//                   name: "name",
//                   description: "description",
//                   currentPrice: 0,
//                   stockCount: 0,
//                   launchDate: nil,
//                   tags: [],
//                   allergicTags: [],
//                   nutritionalInformations: [],
//                   isNew: false)
//    }
//    
//    var deleteContent: [String: String] {
//        ["id": "A"]
//    }
//    
//    private func validateProduct(_ product: APIProductResponse, with expected: Product) {
//        XCTAssertEqual(product.code, expected.code)
//        XCTAssertEqual(product.name, expected.name)
//        XCTAssertEqual(product.description, expected.description)
//        XCTAssertEqual(product.imageUrl, expected.imageUrl)
//        XCTAssertEqual(product.currentPrice, expected.currentPrice)
//        XCTAssertEqual(product.originalPrice, expected.originalPrice)
//        XCTAssertEqual(product.stockCount, expected.stockCount)
//        XCTAssertNotNil(product.launchDate)
//    }
//
//    private func validateTags(_ tags: [APIProductTag], with expectedTag: ProductTag) {
//        XCTAssertEqual(tags.first?.code, expectedTag.code)
//        XCTAssertEqual(tags.first?.description, expectedTag.description)
//    }
//
//    private func validateNutritionalInfo(_ nutritionalInfo: [APINutritionalInformation], with expectedInfo: NutritionalInformation) {
//        XCTAssertEqual(nutritionalInfo.first?.code, expectedInfo.code)
//        XCTAssertEqual(nutritionalInfo.first?.name, expectedInfo.name)
//        XCTAssertEqual(nutritionalInfo.first?.dailyRepresentation, expectedInfo.dailyRepresentation)
//        XCTAssertEqual(nutritionalInfo.first?.quantityDescription, expectedInfo.quantityDescription)
//    }
//}
