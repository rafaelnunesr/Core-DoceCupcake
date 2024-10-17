import Vapor

protocol ControllerFactoryProtocol {
    func makeControllers() throws -> [RouteCollection]
}

final class ControllerFactory: ControllerFactoryProtocol {
    private let userControllerFactory: UserControllerFactoryProtocol
    private let productControllerFactory: ProductControllerFactoryProtocol
    private let voucherControllerFactory: VoucherControllerFactoryProtocol
    private let ordersControllerFactory: OrdersControllerFactoryProtocol
    private let deliveryControllerFactory: DeliveryControllerFactoryProtocol
    private let addressControllerFactory: AddressControllerFactoryProtocol
    private let packagesControllerFactory: PackagesControllerFactoryProtocol

    init(userControllerFactory: UserControllerFactoryProtocol,
         productControllerFactory: ProductControllerFactoryProtocol,
         voucherControllerFactory: VoucherControllerFactoryProtocol,
         ordersControllerFactory: OrdersControllerFactoryProtocol,
         deliveryControllerFactory: DeliveryControllerFactoryProtocol,
         addressControllerFactory: AddressControllerFactoryProtocol,
         packagesControllerFactory: PackagesControllerFactoryProtocol) {
        self.userControllerFactory = userControllerFactory
        self.productControllerFactory = productControllerFactory
        self.voucherControllerFactory = voucherControllerFactory
        self.ordersControllerFactory = ordersControllerFactory
        self.deliveryControllerFactory = deliveryControllerFactory
        self.addressControllerFactory = addressControllerFactory
        self.packagesControllerFactory = packagesControllerFactory
    }

    func makeControllers() throws -> [RouteCollection] {
        return [
            try userControllerFactory.makeSignInController(),
            try userControllerFactory.makeUserSignUpController(),
            try userControllerFactory.makeAdminSignUpController(),
            try userControllerFactory.makeSessionController(),
            try userControllerFactory.makeUserController(),
            
            try productControllerFactory.makeProductController(),
            try productControllerFactory.makeProductTagsController(),
            
            try voucherControllerFactory.makeVoucherController(),
            
            try ordersControllerFactory.makeOrderController(),
            
            try deliveryControllerFactory.makeDeliveryController(),
            
            try addressControllerFactory.makeAddressController(),
            
            try packagesControllerFactory.makePackagesController(),
            
            try productControllerFactory.makeProductReviewController()
        ]
    }
}
