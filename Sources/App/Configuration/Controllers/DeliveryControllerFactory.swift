protocol DeliveryControllerFactoryProtocol {
    func makeDeliveryController() throws -> DeliveryController
}

final class DeliveryControllerFactory: DeliveryControllerFactoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
    }

    func makeDeliveryController() throws -> DeliveryController {
        let sessionValidation = dependencyProvider.getUserSessionValidationMiddleware()
        return DeliveryController(userSectionValidation: sessionValidation)
    }
}
