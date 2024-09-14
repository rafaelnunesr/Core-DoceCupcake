import FluentPostgresDriver
import Foundation
import Vapor

protocol ProductControllerProtocol: RouteCollection, Sendable {
    func checkProductAvailability(with code: String, and quantity: Double) async throws -> Bool
    func updateProductAvailability(with code: String, and quantity: Double) async throws
}

struct ProductController: ProductControllerProtocol {
    private let productRepository: ProductRepositoryProtocol
    private let tagsController: ProductTagsControllerProtocol
    private let nutritionalController: NutritionalControllerProtocol
    
    private let userSectionValidation: SessionValidationMiddlewareProtocol
    private let adminSectionValidation: AdminValidationMiddlewareProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         productRepository: ProductRepositoryProtocol,
         tagsController: ProductTagsControllerProtocol,
         nutritionalController: NutritionalControllerProtocol) {
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
            .get(use: fetchProducts)
        
        productRoutes
            .grouped(userSectionValidation)
            .get(":productCode", use: fetchProduct)
        
        productRoutes
            .grouped(adminSectionValidation)
            .post(use: create)
        
        productRoutes
            .grouped(adminSectionValidation)
            .put(use: update)
        
        productRoutes
            .grouped(adminSectionValidation)
            .delete(use: delete)
    }

    @Sendable
    private func fetchProducts(req: Request) async throws -> ProductListResponse {
        let productList = try await productRepository.fetchProducts()
        
        let products = try await productList.asyncMap { product in
            try await createAPIProductResponse(for: product)
        }
        
        return ProductListResponse(count: products.count, products: products)
    }

    @Sendable
    private func fetchProduct(req: Request) async throws -> APIProductResponse {
        guard let id = req.parameters.get("productCode") 
        else { throw APIResponseError.Common.badRequest }

        guard let product = try await productRepository.fetchProduct(with: id) 
        else { throw APIResponseError.Common.notFound }

        let productResponse = try await createAPIProductResponse(for: product)
        return productResponse
    }

    @Sendable
    private func create(req: Request) async throws -> GenericMessageResponse {
        let model: APIProduct = try convertRequestDataToModel(req: req)

        try await ensureProductDoesNotExist(with: model.code)
        try await validateProductTags(tags: model.tags.map { $0.code }, allergicTags: model.allergicTags.map { $0.code })

        let nutritionalIds = try await createNutricionalInformations(with: model.nutritionalInformations)

        let internalProduct = Product(from: model, nutritionalIds: nutritionalIds)
        try await productRepository.create(internalProduct)
            
        return GenericMessageResponse(message: Constants.productCreated)
    }

    @Sendable
    private func update(req: Request) async throws -> GenericMessageResponse {
        let model: APIProduct = try convertRequestDataToModel(req: req)

        guard try await productRepository.fetchProduct(with: model.code) != nil 
        else { throw APIResponseError.Common.notFound }
        
        try await validateProductTags(tags: model.tags.map { $0.code }, allergicTags: model.allergicTags.map { $0.code })

        let nutritionalIds = try await createNutricionalInformations(with: model.nutritionalInformations)

        let internalProduct = Product(from: model, nutritionalIds: nutritionalIds)
        try await productRepository.update(internalProduct)

        return GenericMessageResponse(message: Constants.productUpdated)
    }

    @Sendable
    private func delete(req: Request) async throws -> GenericMessageResponse {
        let model: APIRequestId = try convertRequestDataToModel(req: req)
        guard let product = try await productRepository.fetchProduct(with: model.id) else {
            throw APIResponseError.Common.notFound
        }
       
        try await productRepository.delete(product)
        
        return GenericMessageResponse(message: Constants.productDeleted)
    }
    
    private func ensureProductDoesNotExist(with code: String) async throws {
        if try await productRepository.fetchProduct(with: code) != nil {
            throw APIResponseError.Common.conflict
        }
    }
    
    private func validateProductTags(tags: [String], allergicTags: [String]) async throws {
        async let areTagsValid = tagsController.areTagCodesValid(tags)
        async let areAllergicTagsValid = tagsController.areTagCodesValid(allergicTags)

        let (tagsResult, allergicTagsResult) = try await (areTagsValid, areAllergicTagsValid)
        
        guard tagsResult, allergicTagsResult 
        else { throw APIResponseError.Product.invalidProductTag }
    }
    
    private func createAPIProductResponse(for product: Product) async throws -> APIProductResponse {
        let tags = try await fetchProductTags(with: product.tags)
        let allergicTags = try await fetchProductTags(with: product.allergicTags)
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
            throw APIResponseError.Product.invalidProductTag
        }
    }
    
    private func saveNutritional(for nutritionals: [APINutritionalInformation]) async throws -> [UUID] {
        try await nutritionals.asyncCompactMap {
            try await nutritionalController.saveNutritionalModel(NutritionalInformation(from: $0)).id
        }
    }

    private func fetchProductTags(with tags: [String]) async throws -> [APIProductTag] {
        let models = try await tagsController.fetchTags(tags)
        return models.map { APIProductTag(from: $0) }
    }
    
    func checkProductAvailability(with code: String, and quantity: Double) async throws -> Bool {
        guard let product = try await productRepository.fetchProduct(with: code)
        else { return false }
        return product.stockCount >= quantity
    }
    
    func updateProductAvailability(with code: String, and quantity: Double) async throws {
        guard var product = try await productRepository.fetchProduct(with: code)
        else { throw APIResponseError.Common.internalServerError }
        product.stockCount -= quantity
        
        try await productRepository.update(product)
    }

    enum Constants {
        static let productCreated = "Product created"
        static let productUpdated = "Product updated"
        static let productDeleted = "Product deleted"
    }
}
