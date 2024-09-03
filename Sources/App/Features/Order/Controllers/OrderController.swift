import FluentPostgresDriver
import Vapor

protocol OrderControllerProtocol: RouteCollection {
    
}

struct OrderController: OrderControllerProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: RepositoryProtocol
    
    private let userSectionValidation: SectionValidationMiddlewareProtocol
    private let adminSectionValidation: AdminValidationMiddlewareProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: RepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
        
        userSectionValidation = dependencyProvider.getUserSectionValidationMiddleware()
        adminSectionValidation = dependencyProvider.getAdminSectionValidationMiddleware()
    }

    func boot(routes: RoutesBuilder) throws {
        let ordersRoutes = routes.grouped(Routes.orders.pathValue)
        
        ordersRoutes
            .grouped(userSectionValidation)
            .get(":orderID", use: getOrderById)
        
        ordersRoutes
            .grouped(userSectionValidation)
            .get("/all", use: getOrderByUserId)
        
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
        fatalError()
    }
    
    @Sendable
    private func getOrderByUserId(req: Request) async throws -> [APIOrder] {
        fatalError()
    }
    
    @Sendable
    private func getAllOpenOrders(req: Request) async throws -> [APIOrder] {
        fatalError()
    }
    
    @Sendable
    private func createOrder(req: Request) async throws -> GenericMessageResponse {
        fatalError()
    }
    
    @Sendable
    private func updateOrder(req: Request) async throws -> GenericMessageResponse {
        fatalError()
    }
    
    @Sendable
    private func deleteOrder(req: Request) async throws -> GenericMessageResponse {
        fatalError()
    }

    private enum Constants {
        static let packageCreated = "Package created."
        static let packageDeleted = "Package deleted."
    }
}

