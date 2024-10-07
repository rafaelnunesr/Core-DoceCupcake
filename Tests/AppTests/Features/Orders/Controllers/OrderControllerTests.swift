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
}
