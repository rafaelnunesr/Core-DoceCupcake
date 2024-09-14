import FluentPostgresDriver
import Vapor

struct OrderController: Sendable {
    private let dependencyProvider: DependencyProviderProtocol
    private let orderRepository: OrderRepositoryProtocol
    private let orderItemRepository: OrderItemRepositoryProtocol
    private let sessionController: SessionControllerProtocol
    private let addressController: AddressControllerProtocol
    private let productController: ProductControllerProtocol
    private let cardController: CardControllerProtocol
    
    private let userSectionValidation: SessionValidationMiddlewareProtocol
    private let adminSectionValidation: AdminValidationMiddlewareProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         orderRepository: OrderRepositoryProtocol,
         orderItemRepository: OrderItemRepositoryProtocol,
         sessionController: SessionControllerProtocol,
         addressController: AddressControllerProtocol,
         productController: ProductControllerProtocol,
         cardController: CardControllerProtocol) {
        self.dependencyProvider = dependencyProvider
        self.orderRepository = orderRepository
        self.orderItemRepository = orderItemRepository
        self.sessionController = sessionController
        self.addressController = addressController
        self.productController = productController
        self.cardController = cardController
        
        userSectionValidation = dependencyProvider.getUserSessionValidationMiddleware()
        adminSectionValidation = dependencyProvider.getAdminSessionValidationMiddleware()
    }

    func boot(routes: RoutesBuilder) throws {
        let ordersRoutes = routes.grouped(PathRoutes.orders.path)
        
        ordersRoutes
            .grouped(userSectionValidation)
            .get(":orderID", use: getOrderById)
        
        ordersRoutes
            .grouped(userSectionValidation)
            .get("/all", use: getOrderByUserId)
        
        ordersRoutes
            .grouped(adminSectionValidation)
            .get("/open", use: getOrderByUserId)
        
        ordersRoutes
            .grouped(adminSectionValidation)
            .get("/closed", use: getOrderByUserId)
        
        ordersRoutes
            .grouped(adminSectionValidation)
            .get("/canceled", use: getOrderByUserId)
        
        ordersRoutes
            .grouped(userSectionValidation)
            .post(use: createOrder)
        
        ordersRoutes
            .grouped(adminSectionValidation)
            .put(use: updateOrder)
        
        ordersRoutes
            .grouped(adminSectionValidation)
            .delete(use: deleteOrder)
    }
    
    @Sendable
    private func getOrderById(req: Request) async throws -> APIOrder {
        guard let id = req.parameters.get("orderID"), let uuid = UUID(uuidString: id) else {
            throw APIError.badRequest
        }
        
        guard let order: Order = try await orderRepository.fetchOrderById(uuid) else {
            throw APIError.notFound
        }
        
        guard let address = try await addressController.fetchAddressByUserId(order.userId)
        else { throw APIError.internalServerError }
        
        let items = try await orderItemRepository.fetchOrdersByOrderId(order.id!) // review this
        
       return APIOrder(from: order, address: address, items: items)
    }
    
    @Sendable
    private func getOrderByUserId(req: Request) async throws -> APIOrderList {
        let userId = try await sessionController.fetchLoggedUserId(req: req)
        let orders: [Order] = try await orderRepository.fetchAllOrdersByUserId(userId)
        
        var ordersList = [APIOrder]()
        
        for order in orders {
            if let address = try await addressController.fetchAddressByUserId(order.userId) {  // review this
                let items = try await orderItemRepository.fetchOrdersByOrderId(order.id!)
                ordersList.append(APIOrder(from: order, address: address, items: items))
            }
            
        }
        
        return APIOrderList(count: ordersList.count, orders: ordersList)
    }
    
    @Sendable
    private func getAllOpenOrders(req: Request) async throws -> APIOrderList {
        let userId = try await sessionController.fetchLoggedUserId(req: req)
        
        let orders: [Order] = try await orderRepository.fetchAllOrdersByStatus(.confirmed)
        
        var ordersList = [APIOrder]()
        
        for order in orders {
            if let address = try await addressController.fetchAddressByUserId(order.userId) {  // review this
                let items = try await orderItemRepository.fetchOrdersByOrderId(order.id!)
                ordersList.append(APIOrder(from: order, address: address, items: items))
            }
            
        }
        
        return APIOrderList(count: ordersList.count, orders: ordersList)
    }
    
    @Sendable
    private func getAllClosedOrder(req: Request) async throws -> APIOrderList {
        let userId = try await sessionController.fetchLoggedUserId(req: req)
        
        let orders: [Order] = try await orderRepository.fetchAllOrdersByStatus(.closed)
        
        var ordersList = [APIOrder]()
        
        for order in orders {
            if let address = try await addressController.fetchAddressByUserId(order.userId) {  // review this
                let items = try await orderItemRepository.fetchOrdersByOrderId(order.id!)
                ordersList.append(APIOrder(from: order, address: address, items: items))
            }
            
        }
        
        return APIOrderList(count: ordersList.count, orders: ordersList)
    }
    
    @Sendable
    private func getAllCanceledOrder(req: Request) async throws -> APIOrderList {
        let userId = try await sessionController.fetchLoggedUserId(req: req)
        
        let orders: [Order] = try await orderRepository.fetchAllOrdersByStatus(.cancelled)
        
        var ordersList = [APIOrder]()
        
        for order in orders {
            if let address = try await addressController.fetchAddressByUserId(order.userId) {  // review this
                let items = try await orderItemRepository.fetchOrdersByOrderId(order.id!)
                ordersList.append(APIOrder(from: order, address: address, items: items))
            }
            
        }
        
        return APIOrderList(count: ordersList.count, orders: ordersList)
    }
    
    @Sendable
    private func createOrder(req: Request) async throws -> GenericMessageResponse {
        let model: APIOrderRequest = try convertRequestDataToModel(req: req)
        
        try await checkProductsAvailability(model.products)
        try await updateProductAvailability(model.products)
        let paymentId = try await cardController.processOrder(model.payment)
        
        let userId = try await sessionController.fetchLoggedUserId(req: req)
        
        let order = Order(from: model, userId: userId, paymentId: paymentId, total: 0) // review this
        
        return GenericMessageResponse(message: Constants.orderCreated)
    }
    
    @Sendable
    private func updateOrder(req: Request) async throws -> GenericMessageResponse {
        return GenericMessageResponse(message: Constants.orderUpdated)
    }
    
    @Sendable
    private func deleteOrder(req: Request) async throws -> GenericMessageResponse {
        return GenericMessageResponse(message: Constants.orderDeleted)
    }
    
    private func checkProductsAvailability(_ products: [APIProductOrderRequest]) async throws {
        for product in products {
            guard try await productController.checkProductAvailability(with: product.code, and: product.quantity)
            else { throw APIError.badRequest }
        }
    }
    
    private func updateProductAvailability(_ products: [APIProductOrderRequest]) async throws {
        for product in products {
            try await productController.updateProductAvailability(with: product.code, and: product.quantity)
        }
    }

    private enum Constants {
        static let orderCreated = "Order created."
        static let orderUpdated = "Order updated."
        static let orderDeleted = "Order deleted."
    }
}

/*
@Sendable
private func createNewProduct(req: Request) async throws -> GenericMessageResponse {
    let model: APIProduct = try convertRequestDataToModel(req: req)

    try await ensureProductDoesNotExist(with: model.code)
    try await validateProductTags(tags: model.tags.map { $0.code }, allergicTags: model.allergicTags.map { $0.code })

    let nutritionalIds = try await createNutricionalInformations(with: model.nutritionalInformations)

    let internalProduct = Product(from: model, nutritionalIds: nutritionalIds)
    try await productRepository.createProduct(internalProduct)
        
    return GenericMessageResponse(message: Constants.productCreated)
}
*/
