import FluentPostgresDriver
import Vapor

struct OrderController: Sendable {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: OrderRepositoryProtocol
    private let sessionController: SessionControllerProtocol
    
    private let userSectionValidation: SessionValidationMiddlewareProtocol
    private let adminSectionValidation: AdminValidationMiddlewareProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: OrderRepositoryProtocol,
         sessionController: SessionControllerProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
        self.sessionController = sessionController
        
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
        
        guard let order: Order = try await repository.fetchOrderById(uuid) else {
            throw APIError.notFound
        }
        
       return APIOrder(from: order)
    }
    
    @Sendable
    private func getOrderByUserId(req: Request) async throws -> APIOrderList {
        let userId = try await sessionController.getLoggedUserId(req: req)
        
        let orders: [Order] = try await repository.fetchAllOrdersByUserId(userId)
        
        let apiOrders = orders.map {
            APIOrder(from: $0)
        }
        
        return APIOrderList(count: apiOrders.count, orders: apiOrders)
    }
    
    @Sendable
    private func getAllOpenOrders(req: Request) async throws -> APIOrderList {
        let userId = try await sessionController.getLoggedUserId(req: req)
        
        let orders: [Order] = try await repository.fetchAllOrdersByStatus(.confirmed)
        
        let apiOrders = orders.map {
            APIOrder(from: $0)
        }
        
        return APIOrderList(count: apiOrders.count, orders: apiOrders)
    }
    
    @Sendable
    private func getAllClosedOrder(req: Request) async throws -> APIOrderList {
        let userId = try await sessionController.getLoggedUserId(req: req)
        
        let orders: [Order] = try await repository.fetchAllOrdersByStatus(.closed)
        
        let apiOrders = orders.map {
            APIOrder(from: $0)
        }
        
        return APIOrderList(count: apiOrders.count, orders: apiOrders)
    }
    
    @Sendable
    private func getAllCanceledOrder(req: Request) async throws -> APIOrderList {
        let userId = try await sessionController.getLoggedUserId(req: req)
        
        let orders: [Order] = try await repository.fetchAllOrdersByStatus(.cancelled)
        
        let apiOrders = orders.map {
            APIOrder(from: $0)
        }
        
        return APIOrderList(count: apiOrders.count, orders: apiOrders)
    }
    
    @Sendable
    private func createOrder(req: Request) async throws -> GenericMessageResponse {
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

    private enum Constants {
        static let orderCreated = "Order created."
        static let orderUpdated = "Order updated."
        static let orderDeleted = "Order deleted."
    }
}
