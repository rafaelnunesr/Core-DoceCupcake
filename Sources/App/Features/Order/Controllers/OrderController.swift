import FluentPostgresDriver
import Vapor

struct OrderController: Sendable {
    private let orderRepository: OrderRepositoryProtocol
    private let orderItemRepository: OrderItemRepositoryProtocol
    private let sessionController: SessionControllerProtocol
    private let addressController: AddressControllerProtocol
    private let productController: ProductControllerProtocol
    private let cardController: CardControllerProtocol
    private let vouchersController: VouchersControllerProtocol
    
    private let userSectionValidation: SessionValidationMiddlewareProtocol
    private let adminSectionValidation: AdminValidationMiddlewareProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         orderRepository: OrderRepositoryProtocol,
         orderItemRepository: OrderItemRepositoryProtocol,
         sessionController: SessionControllerProtocol,
         addressController: AddressControllerProtocol,
         productController: ProductControllerProtocol,
         cardController: CardControllerProtocol,
         vouchersController: VouchersControllerProtocol) {
        self.orderRepository = orderRepository
        self.orderItemRepository = orderItemRepository
        self.sessionController = sessionController
        self.addressController = addressController
        self.productController = productController
        self.cardController = cardController
        self.vouchersController = vouchersController
        userSectionValidation = dependencyProvider.getUserSessionValidationMiddleware()
        adminSectionValidation = dependencyProvider.getAdminSessionValidationMiddleware()
    }

    func boot(routes: RoutesBuilder) throws {
        let ordersRoutes = routes.grouped(PathRoutes.orders.path)
        
        ordersRoutes
            .grouped(userSectionValidation)
            .get(":orderNumber", use: fetchOrderByNumber)
        
        ordersRoutes
            .grouped(userSectionValidation)
            .get("/all", use: fetchOrderByUserId)
        
        ordersRoutes
            .grouped(adminSectionValidation)
            .get("/open", use: fetchAllOpenOrders)
        
        ordersRoutes
            .grouped(adminSectionValidation)
            .get("/closed", use: fetchAllClosedOrder)
        
        ordersRoutes
            .grouped(adminSectionValidation)
            .get("/cancelled", use: fetchAllCancelledOrder)
        
        ordersRoutes
            .grouped(userSectionValidation)
            .post(use: create)
        
        ordersRoutes
            .grouped(adminSectionValidation)
            .put(use: update)
        
        ordersRoutes
            .grouped(adminSectionValidation)
            .delete(use: delete)
    }
    
    @Sendable
    private func fetchOrderByNumber(req: Request) async throws -> APIOrder {
        guard let orderNumber = req.parameters.get("orderNumber")
        else { throw APIResponseError.Common.badRequest }
        
        guard let order: Order = try await orderRepository.fetchOrderByNumber(orderNumber),
              let orderId = order.id
        else { throw APIResponseError.Common.notFound }
        
        guard let address = try await addressController.fetchAddressByUserId(order.userId)
        else { throw APIResponseError.Common.internalServerError }
        
        let items = try await orderItemRepository.fetchOrdersByOrderId(orderId)
        
       return APIOrder(from: order, address: address, items: items)
    }
    
    @Sendable
    private func fetchOrderByUserId(req: Request) async throws -> APIOrderList {
        let userId = try await sessionController.fetchLoggedUserId(req: req)
        let orders: [Order] = try await orderRepository.fetchAllOrdersByUserId(userId)
        let result = try await fetchAddressAndItems(orders)
        return APIOrderList(count: result.count, orders: result)
    }
    
    @Sendable
    private func fetchAllOpenOrders(req: Request) async throws -> APIOrderList {
        try await fetchOrders(with: .confirmed)
    }
    
    @Sendable
    private func fetchAllClosedOrder(req: Request) async throws -> APIOrderList {
        try await fetchOrders(with: .closed)
    }
    
    @Sendable
    private func fetchAllCancelledOrder(req: Request) async throws -> APIOrderList {
        try await fetchOrders(with: .cancelled)
    }
    
    @Sendable
    private func create(req: Request) async throws -> GenericMessageResponse {
        let model: APIOrderRequest = try convertRequestDataToModel(req: req)
        
        try await checkProductsAvailability(model.products)
        try await updateProductAvailability(model.products)
        let paymentId = try await cardController.processOrder(model.payment)
        
        let userId = try await sessionController.fetchLoggedUserId(req: req)
        let total = try await calculateTotal(model.products, voucherCode: model.voucherCode)
        
        let order = Order(from: model, userId: userId, paymentId: paymentId, total: total)
        
        return GenericMessageResponse(message: Constants.orderCreated)
    }
    
    @Sendable
    private func update(req: Request) async throws -> GenericMessageResponse {
        let model: APIOrderUpdate = try convertRequestDataToModel(req: req)
        
        guard let order = try await orderRepository.fetchOrderByNumber(model.orderNumber)
        else { throw APIResponseError.Common.notFound }
        
        let copyOrder = order
        copyOrder.updatedAt = Date()
        copyOrder.deliveryStatus = model.deliveryStatus
        copyOrder.orderStatus = model.orderStatus
    
        try await orderRepository.update(copyOrder)
        
        return GenericMessageResponse(message: Constants.orderUpdated)
    }
    
    @Sendable
    private func delete(req: Request) async throws -> GenericMessageResponse {
        // TODO
        return GenericMessageResponse(message: Constants.orderDeleted)
    }
    
    private func checkProductsAvailability(_ products: [APIProductOrderRequest]) async throws {
        for product in products {
            guard try await productController.checkProductAvailability(with: product.code, and: product.quantity)
            else { throw APIResponseError.Common.badRequest }
        }
    }
    
    private func updateProductAvailability(_ products: [APIProductOrderRequest]) async throws {
        for product in products {
            try await productController.updateProductAvailability(with: product.code, and: product.quantity)
        }
    }
    
    private func fetchOrders(with status: OrderStatus) async throws -> APIOrderList {
        let orders: [Order] = try await orderRepository.fetchAllOrdersByStatus(status)
        let result = try await fetchAddressAndItems(orders)
        return APIOrderList(count: result.count, orders: result)
    }
    
    private func fetchAddressAndItems(_ orders: [Order]) async throws -> [APIOrder] {
        var ordersList = [APIOrder]()
        
        for order in orders {
            if let orderId = order.id,
                let address = try await addressController.fetchAddressByUserId(order.userId) {
                let items = try await orderItemRepository.fetchOrdersByOrderId(orderId)
                ordersList.append(APIOrder(from: order, address: address, items: items))
            }
            
        }
        
        return ordersList
    }
    
    private func calculateTotal(_ products: [APIProductOrderRequest], voucherCode: String?) async throws -> Double {
        var total: Double = 0
        
        for product in products {
            if let result = try await productController.fetchProduct(with: product.code) {
                var productsTotal = result.currentPrice * product.quantity
                
                if let voucherCode = product.voucherCode {
                    let voucherValue = try await vouchersController.applyVoucher(result.currentPrice, voucherCode: voucherCode)
                    productsTotal -= voucherValue
                }
                
                total += productsTotal
            }
        }
        
        if let voucherCode {
            let voucherValue = try await vouchersController.applyVoucher(total, voucherCode: voucherCode)
            total -= voucherValue
        }
        
        return total
    }

    private enum Constants {
        static let orderCreated = "Order created."
        static let orderUpdated = "Order updated."
        static let orderDeleted = "Order deleted."
    }
}
