import Vapor

@testable import App

struct MockDeliveryController: DeliveryControllerProtocol {
    func boot(routes: RoutesBuilder) throws {}
    
    func calculateDeliveryFee(zipcode: String) -> Double {
        0
    }
}
