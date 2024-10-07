import Vapor

protocol DeliveryControllerProtocol: Sendable, RouteCollection {
    func calculateDeliveryFee(zipcode: String) -> Double
}

final class DeliveryController: DeliveryControllerProtocol {
    private let userSectionValidation: SessionValidationMiddlewareProtocol
    
    init(userSectionValidation: SessionValidationMiddlewareProtocol) {
        self.userSectionValidation = userSectionValidation
    }
    
    func boot(routes: RoutesBuilder) throws {
        let productRoutes = routes.grouped(PathRoutes.delivery.path)
        
        productRoutes
            .grouped(userSectionValidation)
            .get(":zipcode", use: getDeliveryFee)
    }
    
    @Sendable
    private func getDeliveryFee(req: Request) async throws -> Double {
        guard let zipcode = req.parameters.get("zipcode")
        else { throw APIResponseError.Common.badRequest }
        
        return calculateDeliveryFee(zipcode: zipcode)
    }
    
    func calculateDeliveryFee(zipcode: String) -> Double {
        return 9.99
    }
}
