import XCTVapor

@testable import App

final class OrderControllerTests: XCTestCase {
    private var app: Application!
    private var sut: OrderController!
    private var mockOrderRepository: MockOrderRepository!
    private var mockOrderItemRepository: MockOrderItemRepository!
    private var mockAddressController: MockAddressController!
    private var mockProductController: MockProductController!
    private var mockCardController: MockCardController!
    private var mockVouchersController: MockVouchersController!
    private var mockDeliveryController: MockDeliveryController!
    private var mockSecurity: MockSecurity!
    private var mockDependencyProvider: MockDependencyProvider!
    private var route = PathRoutes.orders.rawValue
    
    override func setUp() async throws {
        app = try await Application.make(.testing)
        mockOrderRepository = MockOrderRepository()
        mockOrderItemRepository = MockOrderItemRepository()
        mockAddressController = MockAddressController()
        mockProductController = MockProductController()
        mockCardController = MockCardController()
        mockVouchersController = MockVouchersController()
        mockDeliveryController = MockDeliveryController()
        mockSecurity = MockSecurity()
        mockDependencyProvider = MockDependencyProvider(app: app, security: mockSecurity)
        sut = OrderController(dependencyProvider: mockDependencyProvider,
                              orderRepository: mockOrderRepository,
                              orderItemRepository: mockOrderItemRepository,
                              addressController: mockAddressController,
                              productController: mockProductController,
                              cardController: mockCardController,
                              vouchersController: mockVouchersController,
                              deliveryController: mockDeliveryController)
    }
    
    override func tearDown() async throws {
        try await self.app.asyncShutdown()
        app = nil
        sut = nil
        mockOrderRepository = nil
        mockOrderItemRepository = nil
        mockAddressController = nil
        mockProductController = nil
        mockCardController = nil
        mockVouchersController = nil
        mockDeliveryController = nil
        mockSecurity = nil
        mockDependencyProvider = nil
    }
    
    func test_when_logged_user_request_valid_order_id_should_return_order_details() throws {
        let order = MockOrder().orderA
        mockOrderRepository.result = order
        mockAddressController.address = MockAddress().addressA
        mockOrderItemRepository.result = MockOrderItem().itemA
        mockProductController.product = MockProduct().productA
        
        sut = OrderController(dependencyProvider: mockDependencyProvider,
                              orderRepository: mockOrderRepository,
                              orderItemRepository: mockOrderItemRepository,
                              addressController: mockAddressController,
                              productController: mockProductController,
                              cardController: mockCardController,
                              vouchersController: mockVouchersController,
                              deliveryController: mockDeliveryController)
        
        try sut.boot(routes: app.routes)
        
        try self.app.test(.GET, "\(route)/123", afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            
            if let bodyResponse: APIOrder = try convertRequestDataToModel(with: response.body) {
                XCTAssertEqual(bodyResponse.number, order.number)
                XCTAssertEqual(bodyResponse.orderStatus.rawValue, order.orderStatus)
                XCTAssertNotNil(bodyResponse.address)
                XCTAssertFalse(bodyResponse.items.isEmpty)
            }
        })
    }
    
    func test_when_logged_user_request_not_valid_order_id_should_return_error() throws {
        sut = OrderController(dependencyProvider: mockDependencyProvider,
                              orderRepository: mockOrderRepository,
                              orderItemRepository: mockOrderItemRepository,
                              addressController: mockAddressController,
                              productController: mockProductController,
                              cardController: mockCardController,
                              vouchersController: mockVouchersController,
                              deliveryController: mockDeliveryController)
        
        try sut.boot(routes: app.routes)
  
        try self.app.test(.GET, "\(route)/123", afterResponse: { response in
            XCTAssertEqual(response.status, .notFound)
        })
    }
    
    func test_when_logged_user_request_all_orders_should_return_orders_details_list() throws {
        let order = MockOrder().orderA
        mockOrderRepository.result = order
        mockAddressController.address = MockAddress().addressA
        mockOrderItemRepository.result = MockOrderItem().itemA
        mockProductController.product = MockProduct().productA
        
        sut = OrderController(dependencyProvider: mockDependencyProvider,
                              orderRepository: mockOrderRepository,
                              orderItemRepository: mockOrderItemRepository,
                              addressController: mockAddressController,
                              productController: mockProductController,
                              cardController: mockCardController,
                              vouchersController: mockVouchersController,
                              deliveryController: mockDeliveryController)
        
        try sut.boot(routes: app.routes)
        
        try self.app.test(.GET, "\(route)/all", afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            
            if let bodyResponse: APIOrderList = try convertRequestDataToModel(with: response.body) {
                XCTAssertEqual(bodyResponse.orders.first?.number, order.number)
                XCTAssertEqual(bodyResponse.orders.first?.orderStatus.rawValue, order.orderStatus)
                XCTAssertNotNil(bodyResponse.orders.first?.address)
                XCTAssertFalse(bodyResponse.orders.first?.items.isEmpty ?? true)
            }
        })
    }
    
//    func test_when_logged_admin_request_all_open_orders_should_return_all_open_orders() throws {
//        let order = MockOrder().orderA
//        mockOrderRepository.result = order
//        mockAddressController.address = MockAddress().addressA
//        mockOrderItemRepository.result = MockOrderItem().itemA
//        mockProductController.product = MockProduct().productA
//        
//        sut = OrderController(dependencyProvider: mockDependencyProvider,
//                              orderRepository: mockOrderRepository,
//                              orderItemRepository: mockOrderItemRepository,
//                              addressController: mockAddressController,
//                              productController: mockProductController,
//                              cardController: mockCardController,
//                              vouchersController: mockVouchersController,
//                              deliveryController: mockDeliveryController)
//        
//        try sut.boot(routes: app.routes)
//        
//        try self.app.test(.GET, "\(route)/opened", afterResponse: { response in
//            XCTAssertEqual(response.status, .ok)
//            
//            if let bodyResponse: APIOrderList = try convertRequestDataToModel(with: response.body) {
//                XCTAssertEqual(bodyResponse.orders.first?.number, order.number)
//                XCTAssertEqual(bodyResponse.orders.first?.orderStatus.rawValue, order.orderStatus)
//                XCTAssertNotNil(bodyResponse.orders.first?.address)
//                XCTAssertFalse(bodyResponse.orders.first?.items.isEmpty ?? true)
//            }
//        })
//    }
    
    func test_when_logged_admin_request_all_closed_orders_should_return_all_closed_orders() throws {
        let order = MockOrder().orderA
        mockOrderRepository.result = order
        mockAddressController.address = MockAddress().addressA
        mockOrderItemRepository.result = MockOrderItem().itemA
        mockProductController.product = MockProduct().productA
        
        sut = OrderController(dependencyProvider: mockDependencyProvider,
                              orderRepository: mockOrderRepository,
                              orderItemRepository: mockOrderItemRepository,
                              addressController: mockAddressController,
                              productController: mockProductController,
                              cardController: mockCardController,
                              vouchersController: mockVouchersController,
                              deliveryController: mockDeliveryController)
        
        try sut.boot(routes: app.routes)
        
        try self.app.test(.GET, "\(route)/closed", afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            
            if let bodyResponse: APIOrderList = try convertRequestDataToModel(with: response.body) {
                XCTAssertEqual(bodyResponse.orders.first?.number, order.number)
                XCTAssertEqual(bodyResponse.orders.first?.orderStatus.rawValue, order.orderStatus)
                XCTAssertNotNil(bodyResponse.orders.first?.address)
                XCTAssertFalse(bodyResponse.orders.first?.items.isEmpty ?? true)
            }
        })
    }
    
    func test_when_logged_admin_request_all_cancelled_orders_should_return_all_cancelled_orders() throws {
        let order = MockOrder().orderA
        mockOrderRepository.result = order
        mockAddressController.address = MockAddress().addressA
        mockOrderItemRepository.result = MockOrderItem().itemA
        mockProductController.product = MockProduct().productA
        
        sut = OrderController(dependencyProvider: mockDependencyProvider,
                              orderRepository: mockOrderRepository,
                              orderItemRepository: mockOrderItemRepository,
                              addressController: mockAddressController,
                              productController: mockProductController,
                              cardController: mockCardController,
                              vouchersController: mockVouchersController,
                              deliveryController: mockDeliveryController)
        
        try sut.boot(routes: app.routes)
        
        try self.app.test(.GET, "\(route)/cancelled", afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            
            if let bodyResponse: APIOrderList = try convertRequestDataToModel(with: response.body) {
                XCTAssertEqual(bodyResponse.orders.first?.number, order.number)
                XCTAssertEqual(bodyResponse.orders.first?.orderStatus.rawValue, order.orderStatus)
                XCTAssertNotNil(bodyResponse.orders.first?.address)
                XCTAssertFalse(bodyResponse.orders.first?.items.isEmpty ?? true)
            }
        })
    }
    
//    func test_when_logged_admin_request_update_order_should_return_generic_message() throws {
//        let order = MockOrder().orderA
//        mockOrderRepository.result = order
//        
//        sut = OrderController(dependencyProvider: mockDependencyProvider,
//                              orderRepository: mockOrderRepository,
//                              orderItemRepository: mockOrderItemRepository,
//                              addressController: mockAddressController,
//                              productController: mockProductController,
//                              cardController: mockCardController,
//                              vouchersController: mockVouchersController,
//                              deliveryController: mockDeliveryController)
//  
//        try sut.boot(routes: app.routes)
//        
//        let expectedResponse = GenericMessageResponse(message: "Order updated.")
//        
//        try self.app.test(.PUT, route, beforeRequest: { request in
//            try request.content.encode(orderUpdate)
//        }, afterResponse: { response in
//            XCTAssertEqual(response.status, .ok)
//            let bodyResponse = convertBodyToGenericMessageResponse(with: response.body)
//            XCTAssertEqual(bodyResponse, expectedResponse)
//        })
//    }
    
    func test_when_logged_admin_request_update_unknowed_order_should_return_error() throws {
        try sut.boot(routes: app.routes)
    
        try self.app.test(.PUT, route, beforeRequest: { request in
            try request.content.encode(orderUpdate)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .notFound)
        })
    }
    
}

extension OrderControllerTests {
    var orderUpdate: APIOrderUpdate {
        APIOrderUpdate(orderNumber: MockOrder().orderA.number,
                       orderStatus: .cancelled)
    }
}
