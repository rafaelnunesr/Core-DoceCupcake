import FluentPostgresDriver
import Vapor
import Fluent

struct OrderController: RouteCollection, Sendable {
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
         sessionController: SessionControllerProtocol,
         addressController: AddressControllerProtocol,
         productController: ProductControllerProtocol,
         cardController: CardControllerProtocol,
         vouchersController: VouchersControllerProtocol,
         deliveryController: DeliveryControllerProtocol) {
        database = dependencyProvider.getDatabaseInstance()
        self.orderRepository = orderRepository
        self.orderItemRepository = orderItemRepository
        self.sessionController = sessionController
        self.addressController = addressController
        self.productController = productController
        self.cardController = cardController
        self.vouchersController = vouchersController
        self.deliveryController = deliveryController
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
        routes.get("open", use: fetchAllOrders(with: .confirmed))
        routes.get("closed", use: fetchAllOrders(with: .closed))
        routes.get("cancelled", use: fetchAllOrders(with: .cancelled))
        routes.put(use: update)
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
    private func create(req: Request) async throws -> GenericMessageResponse {
        let orderRequest: APIOrderRequest = try req.content.decode(APIOrderRequest.self)
        let userId = try await sessionController.fetchLoggedUserId(req: req)
        let address = try await addressController.fetchAddressByUserId(userId)
        
        guard let address
        else { throw APIResponseError.Common.badRequest }
        
        return try await database.transaction { database in
            try await validateAndProcessOrder(orderRequest, userId: userId)
            guard let paymentId = try await cardController.processOrder(orderRequest.payment, userId: userId) else {
                throw APIResponseError.Payment.paymentError
            }
            let order = try await create(from: orderRequest, userId: userId, zipCode: address.zipCode, paymentId: paymentId, addressId: address.requireID())
            
            for product in orderRequest.products {
                guard let prd = try await productController.fetchProduct(with: product.code)
                else { throw APIResponseError.Common.internalServerError }
                
                try await orderItemRepository.create(OrderItem(orderId: order.requireID(),
                                                               productId: prd.requireID(), 
                                                               quantity: product.quantity,
                                                               unitValue: prd.currentPrice,
                                                               orderStatus: 1))
            }
            
            return GenericMessageResponse(message: Constants.orderCreated)
        }
    }
    
    @Sendable
    private func update(req: Request) async throws -> GenericMessageResponse {
        let model: APIOrderUpdate = try req.content.decode(APIOrderUpdate.self)
        let order = try await fetchOrder(by: model.orderNumber)

        order.deliveryStatus = model.deliveryStatus.rawValue
        order.orderStatus = model.orderStatus.rawValue
        order.updatedAt = Date()
        try await orderRepository.update(order)
        return GenericMessageResponse(message: Constants.orderUpdated)
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
        let total = try await calculateTotal(for: model)
        let deliveryFee = deliveryController.calculateDeliveryFee(zipcode: zipCode)
        let order = Order(from: model, number: getOrderNumber(), userId: userId, paymentId: paymentId, total: total, deliveryFee: deliveryFee, addressId: addressId)
        try await orderRepository.create(order)
        return order
    }

    private func calculateTotal(for model: APIOrderRequest) async throws -> Double {
        var total: Double = 0
        
        for product in model.products {
            let prd = try await productController.fetchProduct(with: product.code)
            total += prd?.currentPrice ?? 0
        }
        
        let discount = try await vouchersController.applyVoucher(total, voucherCode: model.voucherCode ?? .empty)
        if total >= discount {
            return total - discount
        }
        return .zero
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
        static let orderDeleted = "Order deleted."
    }
}


//import FluentPostgresDriver
//import Vapor
//
//struct OrderController: RouteCollection, Sendable {
//    private let orderRepository: OrderRepositoryProtocol
//    private let orderItemRepository: OrderItemRepositoryProtocol
//    private let sessionController: SessionControllerProtocol
//    private let addressController: AddressControllerProtocol
//    private let productController: ProductControllerProtocol
//    private let cardController: CardControllerProtocol
//    private let vouchersController: VouchersControllerProtocol
//    private let deliveryController: DeliveryControllerProtocol
//    
//    private let userSectionValidation: SessionValidationMiddlewareProtocol
//    private let adminSectionValidation: AdminValidationMiddlewareProtocol
//
//    init(dependencyProvider: DependencyProviderProtocol,
//         orderRepository: OrderRepositoryProtocol,
//         orderItemRepository: OrderItemRepositoryProtocol,
//         sessionController: SessionControllerProtocol,
//         addressController: AddressControllerProtocol,
//         productController: ProductControllerProtocol,
//         cardController: CardControllerProtocol,
//         vouchersController: VouchersControllerProtocol,
//         deliveryController: DeliveryControllerProtocol) {
//        self.orderRepository = orderRepository
//        self.orderItemRepository = orderItemRepository
//        self.sessionController = sessionController
//        self.addressController = addressController
//        self.productController = productController
//        self.cardController = cardController
//        self.vouchersController = vouchersController
//        self.deliveryController = deliveryController
//        userSectionValidation = dependencyProvider.getUserSessionValidationMiddleware()
//        adminSectionValidation = dependencyProvider.getAdminSessionValidationMiddleware()
//    }
//    
//    func boot(routes: RoutesBuilder) throws {
//        let ordersRoutes = routes.grouped(PathRoutes.orders.path)
//        
//        ordersRoutes
//            .grouped(userSectionValidation)
//            .get(":orderNumber", use: fetchOrderByNumber)
//        
//        ordersRoutes
//            .grouped(userSectionValidation)
//            .get("all", use: fetchOrderByUserId)
//        
//        ordersRoutes
//            .grouped(adminSectionValidation)
//            .get("open", use: fetchAllOpenOrders)
//        
//        ordersRoutes
//            .grouped(adminSectionValidation)
//            .get("closed", use: fetchAllClosedOrder)
//        
//        ordersRoutes
//            .grouped(adminSectionValidation)
//            .get("cancelled", use: fetchAllCancelledOrder)
//        
//        ordersRoutes
//            .grouped(userSectionValidation)
//            .post(use: create)
//        
//        ordersRoutes
//            .grouped(adminSectionValidation)
//            .put(use: update)
//        
//        ordersRoutes
//            .grouped(adminSectionValidation)
//            .delete(use: delete)
//    }
//    
//    @Sendable
//    private func fetchOrderByNumber(req: Request) async throws -> APIOrder {
//        guard let orderNumber = req.parameters.get("orderNumber"),
//                let number = Int(orderNumber)
//        else { throw APIResponseError.Common.badRequest }
//        
//        guard let order: Order = try await orderRepository.fetchOrderByNumber(number),
//              let orderId = order.id
//        else { throw APIResponseError.Common.notFound }
//        
//        guard let address = try await addressController.fetchAddressByUserId(order.userId)
//        else { throw APIResponseError.Common.internalServerError }
//        
//        let items = try await orderItemRepository.fetchOrdersByOrderId(orderId)
//        var products = [APIOrderItem]()
//        
//        for item in items {
//            if let product = try await productController.fetchProduct(with: item.productId) {
//                products.append(APIOrderItem(from: item, product: APIProduct(from: product)))
//            }
//        }
//        
//       return APIOrder(from: order, address: address, items: products)
//    }
//    
//    @Sendable
//    private func fetchOrderByUserId(req: Request) async throws -> APIOrderList {
//        let userId = try await sessionController.fetchLoggedUserId(req: req)
//        let orders: [Order] = try await orderRepository.fetchAllOrdersByUserId(userId)
//        let result = try await fetchAddressAndItems(orders)
//        return APIOrderList(count: result.count, orders: result)
//    }
//    
//    @Sendable
//    private func fetchAllOpenOrders(req: Request) async throws -> APIOrderList {
//        try await fetchOrders(with: .confirmed)
//    }
//    
//    @Sendable
//    private func fetchAllClosedOrder(req: Request) async throws -> APIOrderList {
//        try await fetchOrders(with: .closed)
//    }
//    
//    @Sendable
//    private func fetchAllCancelledOrder(req: Request) async throws -> APIOrderList {
//        try await fetchOrders(with: .cancelled)
//    }
//    
//    @Sendable
//    private func create(req: Request) async throws -> GenericMessageResponse {
//        let model: APIOrderRequest = try convertRequestDataToModel(req: req)
//        
//        let userId = try await sessionController.fetchLoggedUserId(req: req)
//        try await checkProductsAvailability(model.products)
//        try await updateProductAvailability(model.products)
//        guard let paymentId = try await cardController.processOrder(model.payment, userId: userId)
//        else { throw APIResponseError.Payment.paymentError }
//        
//        let total = try await calculateTotal(model.products, voucherCode: model.voucherCode)
//        let address = try await addressController.fetchAddressById(model.addressId)
//        let deliveryFee = deliveryController.calculateDeliveryFee(zipcode: address?.zipCode ?? .empty)
//        
//        let order = Order(from: model, userId: userId, paymentId: paymentId, total: total, deliveryFee: deliveryFee)
//        try await orderRepository.create(order)
//        
//        guard let createdOrder = try await orderRepository.fetchOrderByNumber(order.number)
//        else {
//            try await orderRepository.delete(order)
//            throw APIResponseError.Common.internalServerError
//        }
//        
//        for product in model.products {
//            guard let orderId = order.id,
//                  let productResult = try await productController.fetchProduct(with: product.code),
//                  let productId = productResult.id
//            else {
//                try await orderRepository.delete(order)
//                throw APIResponseError.Common.internalServerError
//            }
//            
//            let item = OrderItem(orderId: orderId,
//                                 productId: productId,
//                                 quantity: product.quantity,
//                                 unitValue: productResult.currentPrice,
//                                 orderStatus: OrderStatus.confirmed.rawValue)
//            try await orderItemRepository.create(item)
//        }
//        
//        return GenericMessageResponse(message: Constants.orderCreated)
//    }
//    
//    @Sendable
//    private func update(req: Request) async throws -> GenericMessageResponse {
//        let model: APIOrderUpdate = try convertRequestDataToModel(req: req)
//        
//        guard let order = try await orderRepository.fetchOrderByNumber(model.orderNumber)
//        else { throw APIResponseError.Common.notFound }
//        
//        let copyOrder = order
//        copyOrder.updatedAt = Date()
//        copyOrder.deliveryStatus = model.deliveryStatus.rawValue
//        copyOrder.orderStatus = model.orderStatus.rawValue
//    
//        try await orderRepository.update(copyOrder)
//        
//        return GenericMessageResponse(message: Constants.orderUpdated)
//    }
//    
//    @Sendable
//    private func delete(req: Request) async throws -> GenericMessageResponse {
//        // TODO
//        return GenericMessageResponse(message: Constants.orderDeleted)
//    }
//    
//    private func checkProductsAvailability(_ products: [APIProductOrderRequest]) async throws {
//        for product in products {
//            guard try await productController.checkProductAvailability(with: product.code, and: product.quantity)
//            else { throw APIResponseError.Common.badRequest }
//        }
//    }
//    
//    private func updateProductAvailability(_ products: [APIProductOrderRequest]) async throws {
//        for product in products {
//            try await productController.updateProductAvailability(with: product.code, and: product.quantity)
//        }
//    }
//    
//    private func fetchOrders(with status: OrderStatus) async throws -> APIOrderList {
//        let orders: [Order] = try await orderRepository.fetchAllOrdersByStatus(status)
//        let result = try await fetchAddressAndItems(orders)
//        return APIOrderList(count: result.count, orders: result)
//    }
//    
//    private func fetchAddressAndItems(_ orders: [Order]) async throws -> [APIOrder] {
//        var ordersList = [APIOrder]()
//        
//        for order in orders {
//            if let orderId = order.id,
//                let address = try await addressController.fetchAddressByUserId(order.userId) {
//                let items = try await orderItemRepository.fetchOrdersByOrderId(orderId)
//                
//                let products = [APIOrderItem]()
//                for item in items {
//                    //products.append(APIOrderItem(from: item, product: APIProduct(from: )))
//                }
//                ordersList.append(APIOrder(from: order, address: address, items: products))
//            }
//            
//        }
//        
//        return ordersList
//    }
//    
//    private func calculateTotal(_ products: [APIProductOrderRequest], voucherCode: String?) async throws -> Double {
//        var total: Double = 0
//        
//        for product in products {
//            if let result = try await productController.fetchProduct(with: product.code) {
//                var productsTotal = result.currentPrice * product.quantity
//                
//                if let voucherCode = product.voucherCode {
//                    let voucherValue = try await vouchersController.applyVoucher(result.currentPrice, voucherCode: voucherCode)
//                    productsTotal -= voucherValue
//                }
//                
//                total += productsTotal
//            }
//        }
//        
//        if let voucherCode {
//            let voucherValue = try await vouchersController.applyVoucher(total, voucherCode: voucherCode)
//            total -= voucherValue
//        }
//        
//        return total
//    }
//
//    private enum Constants {
//        static let orderCreated = "Order created."
//        static let orderUpdated = "Order updated."
//        static let orderDeleted = "Order deleted."
//    }
//}
