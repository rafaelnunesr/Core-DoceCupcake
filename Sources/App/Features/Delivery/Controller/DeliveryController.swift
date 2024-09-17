import Vapor

protocol DeliveryControllerProtocol: Sendable, RouteCollection {
    func calculateDeliveryFee(zipcode: String) -> Double
}

final class DeliveryController: DeliveryControllerProtocol {
    func boot(routes: RoutesBuilder) throws {
        let productRoutes = routes.grouped(PathRoutes.delivery.path)
        
        productRoutes.get(use: getDeliveryFee)
    }
    
    @Sendable
    private func getDeliveryFee(req: Request) async throws -> Double {
        let delivery: APIDeliveryRequest = try convertRequestDataToModel(req: req)
        return calculateDeliveryFee(zipcode: delivery.zipcode)
    }
    
    func calculateDeliveryFee(zipcode: String) -> Double {
        return 9.99
    }
}
