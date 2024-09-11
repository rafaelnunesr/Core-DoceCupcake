import FluentPostgresDriver
import Foundation
import Vapor

struct ProductController: RouteCollection, Sendable {
    private let dependencyProvider: DependencyProviderProtocol
    private let productRepository: ProductRepositoryProtocol
    private let tagsController: ProductTagsControllerProtocol
    private let nutritionalController: NutritionalControllerProtocol
    
    private let userSectionValidation: SessionValidationMiddlewareProtocol
    private let adminSectionValidation: AdminValidationMiddlewareProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         productRepository: ProductRepositoryProtocol,
         tagsController: ProductTagsControllerProtocol,
         nutritionalController: NutritionalControllerProtocol) {
        self.dependencyProvider = dependencyProvider
        self.productRepository = productRepository
        self.tagsController = tagsController
        self.nutritionalController = nutritionalController
        
        userSectionValidation = dependencyProvider.getUserSessionValidationMiddleware()
        adminSectionValidation = dependencyProvider.getAdminSessionValidationMiddleware()
    }

    func boot(routes: RoutesBuilder) throws {
        let productRoutes = routes.grouped(PathRoutes.products.path)
        
        productRoutes
            .grouped(userSectionValidation)
            .get(use: getProductList)
        
        productRoutes
            .grouped(userSectionValidation)
            .get(":productCode", use: getProduct)
        
        productRoutes
            .grouped(adminSectionValidation)
            .post(use: createNewProduct)
        
        productRoutes
            .grouped(adminSectionValidation)
            .put(use: updateProduct)
        
        productRoutes
            .grouped(adminSectionValidation)
            .delete(use: deleteProduct)
    }

    @Sendable
    private func getProductList(req: Request) async throws -> ProductListResponse {
        let productList = try await productRepository.getProductList()
        
        let products = try await productList.asyncMap { product in
            try await createAPIProductResponse(for: product)
        }
        
        return ProductListResponse(count: products.count, products: products)
    }

    @Sendable
    private func getProduct(req: Request) async throws -> APIProductResponse {
        guard let id = req.parameters.get("productCode") else {
            throw APIError.badRequest
        }

        guard let product = try await productRepository.getProduct(with: id) else {
            throw APIError.notFound
        }

        let productResponse = try await createAPIProductResponse(for: product)
        return productResponse
    }

    @Sendable
    private func createNewProduct(req: Request) async throws -> GenericMessageResponse {
        let model: APIProduct = try convertRequestDataToModel(req: req)

        try await ensureProductDoesNotExist(with: model.code)
        try await validateProductTags(tags: model.tags.map { $0.code }, allergicTags: model.allergicTags.map { $0.code })

        let nutritionalIds = try await createNutricionalInformations(with: model.nutritionalInformations)

        let internalProduct = Product(from: model, nutritionalIds: nutritionalIds)
        try await productRepository.createProduct(internalProduct)
            
        return GenericMessageResponse(message: Constants.productCreated)
    }

    @Sendable
    private func updateProduct(req: Request) async throws -> GenericMessageResponse {
        let model: APIProduct = try convertRequestDataToModel(req: req)

        guard try await productRepository.getProduct(with: model.code) != nil else {
            throw APIError.notFound
        }
        
        try await validateProductTags(tags: model.tags.map { $0.code }, allergicTags: model.allergicTags.map { $0.code })

        let nutritionalIds = try await createNutricionalInformations(with: model.nutritionalInformations)

        let internalProduct = Product(from: model, nutritionalIds: nutritionalIds)
        try await productRepository.updateProduct(internalProduct)

        return GenericMessageResponse(message: Constants.productUpdated)
    }

    @Sendable
    private func deleteProduct(req: Request) async throws -> GenericMessageResponse {
        let model: APIRequestId = try convertRequestDataToModel(req: req)
        guard let product = try await productRepository.getProduct(with: model.id) else {
            throw APIError.notFound
        }
       
        try await productRepository.deleteProduct(product)
        
        return GenericMessageResponse(message: Constants.productDeleted)
    }
    
    private func ensureProductDoesNotExist(with code: String) async throws {
        if try await productRepository.getProduct(with: code) != nil {
            throw APIError.conflict
        }
    }
    
    private func validateProductTags(tags: [String], allergicTags: [String]) async throws {
        async let areTagsValid = tagsController.areTagCodesValid(tags)
        async let areAllergicTagsValid = tagsController.areTagCodesValid(allergicTags)

        let (tagsResult, allergicTagsResult) = try await (areTagsValid, areAllergicTagsValid)
        
        guard tagsResult, allergicTagsResult else {
            throw Abort(.badRequest, reason: APIErrorMessage.Product.invalidProductTag)
        }
    }
    
    private func createAPIProductResponse(for product: Product) async throws -> APIProductResponse {
        let tags = try await getProductTags(with: product.tags)
        let allergicTags = try await getProductTags(with: product.allergicTags)
        let nutritionalModels = try await nutritionalController.getNutritionalByIds(product.nutritionalIds)

        return APIProductResponse(
            from: product,
            tags: tags,
            allergicTags: allergicTags,
            nutritionalInfos: nutritionalModels.map { APINutritionalInformation(from: $0) }
        )
    }
    
    private func createNutricionalInformations(with nutritionalInformations: [APINutritionalInformation]) async throws -> [UUID] {
        try await nutritionalInformations.asyncCompactMap { information in
            try await nutritionalController.saveNutritionalModel(NutritionalInformation(from: information)).id
        }
    }
    
    private func validateTagsAndAllergies(tags: [String], allergies: [String]) async throws {
        async let areTagsValid = tagsController.areTagCodesValid(tags)
        async let areAllergiesValid = tagsController.areTagCodesValid(allergies)

        guard try await areTagsValid, try await areAllergiesValid else {
            throw Abort(.badRequest, reason: APIErrorMessage.Product.invalidProductTag)
        }
    }
    
    private func saveNutritional(for nutritionals: [APINutritionalInformation]) async throws -> [UUID] {
        try await nutritionals.asyncCompactMap {
            try await nutritionalController.saveNutritionalModel(NutritionalInformation(from: $0)).id
        }
    }

    private func getProductTags(with tags: [String]) async throws -> [APIProductTag] {
        let models = try await tagsController.getTagsFor(tags)
        return models.map { APIProductTag(from: $0) }
    }

    enum Constants {
        static let productCreated = "Product created"
        static let productUpdated = "Product updated"
        static let productDeleted = "Product deleted"
    }
}
