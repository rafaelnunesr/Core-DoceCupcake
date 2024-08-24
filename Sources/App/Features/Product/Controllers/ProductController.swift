import FluentPostgresDriver
import Foundation
import Vapor

struct ProductController: RouteCollection {
    private let dependencyProvider: DependencyProviderProtocol
    private let productRepository: ProductRepositoryProtocol
    private let tagsController: ProductTagsControllerProtocol
    private let nutritionalController: NutritionalControllerProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         productRepository: ProductRepositoryProtocol,
         tagsController: ProductTagsControllerProtocol,
         nutritionalController: NutritionalControllerProtocol) {
        self.dependencyProvider = dependencyProvider
        self.productRepository = productRepository
        self.tagsController = tagsController
        self.nutritionalController = nutritionalController
    }

    func boot(routes: RoutesBuilder) throws {
        let productRoutes = routes.grouped("productList")
        productRoutes.get(use: getProductList)
        productRoutes.get(":productID", use: getProduct)
        productRoutes.post(use: createNewProduct)
        productRoutes.put(use: updateProduct)
        productRoutes.delete(use: deleteProduct)
    }

    private func getProductList(req: Request) async throws -> APIProductListResponse {
        let productList = try await productRepository.getProductList()

        let (tagsModels, allergicModels) = try await getProductTagsModel(productList)

        var productResponse = [APIProductResponse]()

        for product in productList {
            var prd = APIProductResponse(from: product)
            prd.tags = tagsModels.map { APIProductTagModel(from: $0) }
            prd.allergicTags = allergicModels.map { APIProductTagModel(from: $0) }
            productResponse.append(prd)
        }

        return APIProductListResponse(count: productResponse.count, products: productResponse)
    }

    private func getProduct(req: Request) async throws -> APIProductResponse {
        guard let id = req.parameters.get("productID") else {
            throw Abort(.badRequest, reason: APIErrorMessage.Common.badRequest)
        }

        guard let product = try await productRepository.getProduct(with: id) else {
            throw Abort(.notFound, reason: APIErrorMessage.Common.notFound)
        }

        let (tagsModels, allergicModels) = try await getProductTagsModel([product])
        
        let nutritionalModel = try await nutritionalController.getNutritionalByIds(product.nutritionalIds)

        var productResponse = APIProductResponse(from: product)
        productResponse.tags = tagsModels.map { APIProductTagModel(from: $0) }
        productResponse.allergicTags = allergicModels.map { APIProductTagModel(from: $0) }
        productResponse.nutritionalInformations = nutritionalModel.map { APINutritionalInformation(from: $0) }

        return productResponse
    }

    private func createNewProduct(req: Request) async throws -> APIGenericMessageResponse {
        // check user privilegies
        let model: APIProductModel = try convertRequestDataToModel(req: req)

        guard try await productRepository.getProduct(with: model.id) == nil else {
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
            let result = try await nutritionalController.saveNutritionalModel(InternalNutritionalModel(from: nutritionalModel))
            if let id = result.id {
                nutritionalIds.append(id)
            }
        }

        let internalProduct = InternalProductModel(from: model, nutritionalIds: nutritionalIds)
        try await productRepository.createProduct(internalProduct)

        return APIGenericMessageResponse(message: Constants.productCreated)
    }

    private func getProductTagsModel(_ productList: [InternalProductModel]) async throws -> (tags: [InternalProductTagModel], allergicTags: [InternalProductTagModel]) {
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

    private func updateProduct(req: Request) async throws -> String {
        // check user privilegies
        .empty
    }

    private func deleteProduct(req: Request) async throws -> String {
        // check user privilegies
        .empty
    }

    private enum Constants {
        static let productCreated = "Product created"
    }
}
