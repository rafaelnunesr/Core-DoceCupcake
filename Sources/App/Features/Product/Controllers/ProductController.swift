import FluentPostgresDriver
import Foundation
import Vapor

struct ProductController: RouteCollection {
    private let dependencyProvider: DependencyProviderProtocol
    private let productRepository: ProductRepositoryProtocol
    private let tagsController: ProductTagsControllerProtocol
    private let nutritionalController: NutritionalControllerProtocol
    
    private let userSectionValidation: SectionValidationMiddlewareProtocol
    private let adminSectionValidation: AdminValidationMiddlewareProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         productRepository: ProductRepositoryProtocol,
         tagsController: ProductTagsControllerProtocol,
         nutritionalController: NutritionalControllerProtocol) {
        self.dependencyProvider = dependencyProvider
        self.productRepository = productRepository
        self.tagsController = tagsController
        self.nutritionalController = nutritionalController
        
        userSectionValidation = dependencyProvider.getUserSectionValidationMiddleware()
        adminSectionValidation = dependencyProvider.getAdminSectionValidationMiddleware()
    }

    func boot(routes: RoutesBuilder) throws {
        let productRoutes = routes.grouped("productList")
        
        productRoutes
            .grouped(userSectionValidation)
            .get(use: getProductList)
        
        productRoutes
            .grouped(userSectionValidation)
            .get(":productID", use: getProduct)
        
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

    private func getProductList(req: Request) async throws -> ProductListResponse {
        let productList = try await productRepository.getProductList()

        let (tagsModels, allergicModels) = try await getProductTagsModel(productList)

        var productResponse = [APIProduct]()

        for product in productList {
            var prd = APIProduct(from: product, nutritionalInfos: []) // TODO
            productResponse.append(prd)
        }

        return ProductListResponse(count: productResponse.count, products: productResponse)
    }

    private func getProduct(req: Request) async throws -> APIProduct {
        guard let id = req.parameters.get("productID") else {
            throw Abort(.badRequest, reason: APIErrorMessage.Common.badRequest)
        }

        guard let product = try await productRepository.getProduct(with: id) else {
            throw Abort(.notFound, reason: APIErrorMessage.Common.notFound)
        }

        let (tagsModels, allergicModels) = try await getProductTagsModel([product])
        
        let nutritionalModel = try await nutritionalController.getNutritionalByIds(product.nutritionalIds)

        var productResponse = APIProduct(from: product, nutritionalInfos: []) // TODO
        productResponse.nutritionalInformations = nutritionalModel.map { APINutritionalInformation(from: $0) }

        return productResponse
    }

    private func createNewProduct(req: Request) async throws -> GenericMessageResponse {
        let model: APIProduct = try convertRequestDataToModel(req: req)

        guard try await productRepository.getProduct(with: model.productId) == nil else {
            throw Abort(.conflict, reason: APIErrorMessage.Common.conflict)
        }

        let tagCodes = model.tags.map { $0.code }
        let allergicCodes = model.allergicTags.map { $0.code }

        let tagsResult = try await tagsController.areTagCodesValid(tagCodes)
        let allergicCodesResult = try await tagsController.areTagCodesValid(allergicCodes)

        guard tagsResult, allergicCodesResult else {
            throw Abort(.badRequest, reason: APIErrorMessage.Product.invalidProductTag)
        }

        var nutritionalIds = [UUID]()
        for nutritionalModel in model.nutritionalInformations {
            let result = try await nutritionalController.saveNutritionalModel(NutritionalInformation(from: nutritionalModel))
            if let id = result.id {
                nutritionalIds.append(id)
            }
        }

        let internalProduct = Product(from: model, nutritionalIds: nutritionalIds)
        try await productRepository.createProduct(internalProduct)

        return GenericMessageResponse(message: Constants.productCreated)
    }

    private func getProductTagsModel(_ productList: [Product]) async throws -> (tags: [ProductTag], allergicTags: [ProductTag]) {
        var productTags = [String]()
        var allergicTags = [String]()

        for product in productList {
            productTags.append(contentsOf: product.tags)
            allergicTags.append(contentsOf: product.allergicTags)
        }

        let tagsModels = try await tagsController.getTagsFor(productTags)
        let allergicModels = try await tagsController.getTagsFor(allergicTags)

        return (tags: tagsModels, allergicTags: allergicModels)
    }

    private func updateProduct(req: Request) async throws -> GenericMessageResponse {
        let model: APIProduct = try convertRequestDataToModel(req: req)

        guard let product = try await productRepository.getProduct(with: model.productId) else {
            throw Abort(.notFound, reason: APIErrorMessage.Common.notFound)
        }
        
        let tagCodes = model.tags.map { $0.code }
        let allergicCodes = model.allergicTags.map { $0.code }

        let tagsResult = try await tagsController.areTagCodesValid(tagCodes)
        let allergicCodesResult = try await tagsController.areTagCodesValid(allergicCodes)

        guard tagsResult, allergicCodesResult else {
            throw Abort(.badRequest, reason: APIErrorMessage.Product.invalidProductTag)
        }

        var nutritionalIds = [UUID]()
        for nutritionalModel in model.nutritionalInformations {
            let result = try await nutritionalController.saveNutritionalModel(NutritionalInformation(from: nutritionalModel))
            if let id = result.id {
                nutritionalIds.append(id)
            }
        }

        let internalProduct = Product(from: model, nutritionalIds: nutritionalIds)
        try await productRepository.updateProduct(internalProduct)

        return GenericMessageResponse(message: Constants.productCreated)
    }

    private func deleteProduct(req: Request) async throws -> GenericMessageResponse {
        let model: APIDeleteInfo = try convertRequestDataToModel(req: req)
        guard let product = try await productRepository.getProduct(with: model.id) else {
            throw Abort(.notFound, reason: APIErrorMessage.Common.notFound)
        }
       
        try await productRepository.deleteProduct(product)
        
        return GenericMessageResponse(message: Constants.productDeleted)
    }

    private enum Constants {
        static let productCreated = "Product created"
        static let productUpdated = "Product updated"
        static let productDeleted = "Product deleted"
    }
}
