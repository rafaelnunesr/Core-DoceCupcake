import FluentPostgresDriver
import Vapor
import Fluent

protocol OrderControllerProtocol: RouteCollection, Sendable {
    func updateOrderWithReviewId(_ reviewId: UUID, orderId: UUID, productId: UUID) async throws
}

struct OrderController: OrderControllerProtocol {
    // MARK: - Dependencies
    private var database: Database
    private let orderRepository: OrderRepositoryProtocol
    private let orderItemRepository: OrderItemRepositoryProtocol
    private let sessionController: SessionControllerProtocol
    private let addressController: AddressControllerProtocol
    private let productController: ProductControllerProtocol
    private let cardController: CardControllerProtocol
    private let vouchersController: VouchersControllerProtocol
    private let deliveryController: DeliveryControllerProtocol
    private let userSectionValidation: SessionValidationMiddlewareProtocol
    private let adminSectionValidation: AdminValidationMiddlewareProtocol
    
    // MARK: - Initializer
    init(dependencyProvider: DependencyProviderProtocol,
         orderRepository: OrderRepositoryProtocol,
         orderItemRepository: OrderItemRepositoryProtocol,
         addressController: AddressControllerProtocol,
         productController: ProductControllerProtocol,
         cardController: CardControllerProtocol,
         vouchersController: VouchersControllerProtocol,
         deliveryController: DeliveryControllerProtocol) {
        database = dependencyProvider.getDatabaseInstance()
        self.orderRepository = orderRepository
        self.orderItemRepository = orderItemRepository
        self.addressController = addressController
        self.productController = productController
        self.cardController = cardController
        self.vouchersController = vouchersController
        self.deliveryController = deliveryController
        self.sessionController = dependencyProvider.getSessionController()
        self.userSectionValidation = dependencyProvider.getUserSessionValidationMiddleware()
        self.adminSectionValidation = dependencyProvider.getAdminSessionValidationMiddleware()
    }

    // MARK: - Routes Setup
    func boot(routes: RoutesBuilder) throws {
        let ordersRoutes = routes.grouped(PathRoutes.orders.path)

        setupUserRoutes(on: ordersRoutes.grouped(userSectionValidation))
        setupAdminRoutes(on: ordersRoutes.grouped(adminSectionValidation))
    }

    private func setupUserRoutes(on routes: RoutesBuilder) {
        routes.get(":orderNumber", use: fetchOrderByNumber)
        routes.get("all", use: fetchOrderByUserId)
        routes.post(use: create)
    }

    private func setupAdminRoutes(on routes: RoutesBuilder) {
        //routes.get("opened", use: fetchAllOrders(with: .confirmed))
        routes.get("closed", use: fetchAllOrders(with: .delivered))
        routes.get("cancelled", use: fetchAllOrders(with: .cancelled))
        routes.put(use: update)
    }
    
    func updateOrderWithReviewId(_ reviewId: UUID, orderId: UUID, productId: UUID) async throws {
        guard let order = try await orderRepository.fetchOrderById(orderId)
        else { throw APIResponseError.Common.notFound }
        let items = try await orderItemRepository.fetchOrdersByOrderId(order.requireID())
        let item = items.first(where: { $0.productId == productId })
        item?.reviewId = reviewId
        
        guard let item
        else { throw APIResponseError.Common.internalServerError }
        
        try await orderItemRepository.update(item)
    }

    // MARK: - Handlers

    @Sendable
    private func fetchOrderByNumber(req: Request) async throws -> APIOrder {
        let orderNumber = try extractOrderNumber(from: req)
        let order = try await fetchOrder(by: orderNumber)
        let address = try await fetchAddress(for: order)
        let items = try await fetchOrderItems(for: order)

        return APIOrder(from: order, address: address, items: items)
    }

    @Sendable
    private func fetchOrderByUserId(req: Request) async throws -> APIOrderList {
        let userId = try await sessionController.fetchLoggedUserId(req: req)
        let orders = try await orderRepository.fetchAllOrdersByUserId(userId)
        let orderList = try await fetchOrderDetails(for: orders)

        return APIOrderList(count: orderList.count, orders: orderList)
    }
    
    @Sendable
    private func create(req: Request) async throws -> APIOrder {
        let orderRequest: APIOrderRequest = try req.content.decode(APIOrderRequest.self)
        let userId = try await sessionController.fetchLoggedUserId(req: req)
        let address = try await addressController.fetchAddressByUserId(userId)
        
        guard let address else {
            throw APIResponseError.Common.badRequest
        }
        
        return try await database.transaction { database in
            try await validateAndProcessOrder(orderRequest, userId: userId)
            guard let paymentId = try await cardController.processOrder(orderRequest.payment, userId: userId) else {
                throw APIResponseError.Payment.paymentError
            }
            
            let order = try await create(from: orderRequest,
                                         userId: userId,
                                         zipCode: address.zipCode,
                                         paymentId: paymentId,
                                         addressId: address.requireID())
            
            for product in orderRequest.products {
                guard let prd = try await productController.fetchProduct(with: product.code) else {
                    throw APIResponseError.Common.internalServerError
                }
                
                try await orderItemRepository.create(OrderItem(orderId: order.requireID(),
                                                               productId: prd.requireID(),
                                                               quantity: product.quantity,
                                                               unitValue: prd.currentPrice,
                                                               orderStatus: 1))
            }
            
            let items = try await fetchOrderItems(for: order)
            let apiOrder = APIOrder(from: order, address: address, items: items)
            return apiOrder
        }
    }

    @Sendable
    private func update(req: Request) async throws -> APIOrder {
        let model: APIOrderUpdate = try req.content.decode(APIOrderUpdate.self)
        let order = try await fetchOrder(by: model.orderNumber)

        order.orderStatus = model.orderStatus.rawValue
        order.updatedAt = Date()
        try await orderRepository.update(order)
        
        let address = try await fetchAddress(for: order)
        
        let internalItems = try await orderItemRepository.fetchOrdersByOrderId(order.requireID())
        
        for item in internalItems {
            var copyItem = item
            copyItem.orderStatus = model.orderStatus.rawValue
            try await orderItemRepository.update(copyItem)
        }
        
        let items = try await fetchOrderItems(for: order)
        
        let apiOrder = APIOrder(from: order, address: address, items: items)
        return apiOrder
    }
    
    // MARK: - Private Helper Methods

    @Sendable
    private func fetchAllOrders(with status: OrderStatus) -> (Request) async throws -> APIOrderList {
        return { req in
            let orders = try await self.orderRepository.fetchAllOrdersByStatus(status)
            let orderList = try await self.fetchOrderDetails(for: orders)

            return APIOrderList(count: orderList.count, orders: orderList)
        }
    }

    private func extractOrderNumber(from req: Request) throws -> String {
        guard let orderNumberString = req.parameters.get("orderNumber")
        else { throw APIResponseError.Common.badRequest }
        return orderNumberString
    }
    
    private func getOrderNumber() -> String {
        let currentDate = Date()
            let secondsFrom1970 = Int(currentDate.timeIntervalSince1970)
            let year = Calendar.current.component(.year, from: currentDate)
            let timestampString = "\(year)\(secondsFrom1970)"
            return timestampString
    }

    private func fetchOrder(by number: String) async throws -> Order {
        guard let order = try await orderRepository.fetchOrderByNumber(number) else {
            throw APIResponseError.Common.notFound
        }
        return order
    }

    private func fetchAddress(for order: Order) async throws -> Address {
        guard let address = try await addressController.fetchAddressByUserId(order.userId) else {
            throw APIResponseError.Common.internalServerError
        }
        return address
    }

    private func fetchOrderItems(for order: Order) async throws -> [APIOrderItem] {
        guard let orderId = order.id else { return [] }
        let items = try await orderItemRepository.fetchOrdersByOrderId(orderId)
        return try await items.asyncMap { item in
            guard let product = try await productController.fetchProduct(with: item.productId) else {
                throw APIResponseError.Common.internalServerError
            }
            return APIOrderItem(from: item, product: APIProduct(from: product))
        }
    }

    private func validateAndProcessOrder(_ orderRequest: APIOrderRequest, userId: UUID) async throws {
        try await checkProductsAvailability(orderRequest.products)
        try await updateProductAvailability(orderRequest.products)
    }

    private func create(from model: APIOrderRequest, userId: UUID, zipCode: String, paymentId: UUID, addressId: UUID) async throws -> Order {
        let subtotal = try await calculateSubtotal(for: model)
        let total = try await calculateTotal(for: model)
        let deliveryFee = deliveryController.calculateDeliveryFee(zipcode: zipCode)
        let voucher = try await vouchersController.getVoucher(with: model.voucherCode ?? .empty)
        var discount: Double = 0
        
        
        if let voucher {
            discount = try await vouchersController.calculateVoucherDiscount(total, voucher: voucher)
        }
        
        let order = Order(from: model, number: getOrderNumber(), userId: userId,
                          paymentId: paymentId, total: total + deliveryFee, discount: discount,
                          deliveryFee: deliveryFee, subtotal: subtotal, addressId: addressId)
        try await orderRepository.create(order)
        return order
    }

    private func calculateSubtotal(for model: APIOrderRequest) async throws -> Double {
        var total: Double = 0
        
        for product in model.products {
            let prd = try await productController.fetchProduct(with: product.code)
            if let currentPrice = prd?.currentPrice {
                total += currentPrice * product.quantity
            }
        }
        
        return total
    }

    private func calculateTotal(for model: APIOrderRequest) async throws -> Double {
        let subtotal = try await calculateSubtotal(for: model)
        
        if let voucherCode = model.voucherCode {
            let voucher = try await vouchersController.getVoucher(with: voucherCode)
            
            if let voucher {
                let discount = try await vouchersController.calculateVoucherDiscount(subtotal, voucher: voucher)
                try await vouchersController.applyVoucher(subtotal, voucherCode: voucherCode)
                
                if subtotal >= discount {
                    return subtotal - discount
                }
            }
        }
        
        return subtotal
    }

    private func checkProductsAvailability(_ products: [APIProductOrderRequest]) async throws {
        for product in products {
            guard try await productController.checkProductAvailability(with: product.code, and: product.quantity) else {
                throw APIResponseError.Common.badRequest
            }
        }
    }

    private func updateProductAvailability(_ products: [APIProductOrderRequest]) async throws {
        for product in products {
            try await productController.updateProductAvailability(with: product.code, and: product.quantity)
        }
    }

    private func fetchOrderDetails(for orders: [Order]) async throws -> [APIOrder] {
        return try await orders.asyncMap { order in
            let address = try await fetchAddress(for: order)
            let items = try await fetchOrderItems(for: order)
            return APIOrder(from: order, address: address, items: items)
        }
    }
    
    // MARK: - Constants
    private enum Constants {
        static let orderCreated = "Order created."
        static let orderUpdated = "Order updated."
    }
}
