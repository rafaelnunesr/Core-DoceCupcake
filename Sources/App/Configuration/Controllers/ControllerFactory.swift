import Vapor

protocol ControllerFactoryProtocol {
    func makeControllers() throws -> [RouteCollection]
}

final class ControllerFactory: ControllerFactoryProtocol {
    private let userControllerFactory: UserControllerFactoryProtocol
    private let productControllerFactory: ProductControllerFactoryProtocol
    private let voucherControllerFactory: VoucherControllerFactoryProtocol
    private let ordersControllerFactory: OrdersControllerFactoryProtocol

    init(userControllerFactory: UserControllerFactoryProtocol,
         productControllerFactory: ProductControllerFactoryProtocol,
         voucherControllerFactory: VoucherControllerFactoryProtocol,
         ordersControllerFactory: OrdersControllerFactoryProtocol) {
        self.userControllerFactory = userControllerFactory
        self.productControllerFactory = productControllerFactory
        self.voucherControllerFactory = voucherControllerFactory
        self.ordersControllerFactory = ordersControllerFactory
    }

    func makeControllers() throws -> [RouteCollection] {
        return [
            try userControllerFactory.makeSignInController(),
            try userControllerFactory.makeUserSignUpController(),
            try userControllerFactory.makeAdminSignUpController(),
            try productControllerFactory.makeProductController(),
            try productControllerFactory.makeProductTagsController(),
            //try productControllerFactory.makeProductReviewController(),
            try voucherControllerFactory.makeVoucherController(),
            
            try ordersControllerFactory.makeOrderController()
        ]
    }
}
