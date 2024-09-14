import Vapor

final class DeliveryController: RouteCollection, Sendable {
    func boot(routes: RoutesBuilder) throws {
        let productRoutes = routes.grouped(PathRoutes.delivery.path)
        
        productRoutes.get(use: getDeliveryFee)
    }
    
    @Sendable
    private func getDeliveryFee(req: Request) async throws -> Double {
        let delivery: APIDeliveryRequest = try convertRequestDataToModel(req: req)
        return 9.99
    }
}
