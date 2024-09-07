import Vapor

protocol ControllerFactoryProtocol {
    func makeControllers() throws -> [RouteCollection]
}

final class ControllerFactory: ControllerFactoryProtocol {
    private let userControllerFactory: UserControllerFactoryProtocol
    private let productControllerFactory: ProductControllerFactoryProtocol
    private let voucherControllerFactory: VoucherControllerFactoryProtocol

    init(userControllerFactory: UserControllerFactoryProtocol,
         productControllerFactory: ProductControllerFactoryProtocol,
         voucherControllerFactory: VoucherControllerFactoryProtocol) {
        self.userControllerFactory = userControllerFactory
        self.productControllerFactory = productControllerFactory
        self.voucherControllerFactory = voucherControllerFactory
    }

    func makeControllers() throws -> [RouteCollection] {
        return [
            try userControllerFactory.makeSignInController(),
            try userControllerFactory.makeUserSignUpController(),
            try userControllerFactory.makeAdminSignUpController(),
//            try productControllerFactory.makeProductController(),
//            try productControllerFactory.makeProductTagsController(),
//            try productControllerFactory.makeProductReviewController(),
//            try voucherControllerFactory.makeVoucherController()
        ]
    }
}
