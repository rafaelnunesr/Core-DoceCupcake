import FluentPostgresDriver
import Foundation
import Vapor

struct ProductController: RouteCollection {
    private let dependencyProvider: DependencyProviderProtocol
    private let productRepository: ProductRepositoryProtocol
    private let tagsRepository: ProductTagsRepositoryProtocol
    private let nutritionalController: NutritionalControllerProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         productRepository: ProductRepositoryProtocol,
         tagsRepository: ProductTagsRepositoryProtocol,
         nutritionalController: NutritionalControllerProtocol) {
        self.dependencyProvider = dependencyProvider
        self.productRepository = productRepository
        self.tagsRepository = tagsRepository
        self.nutritionalController = nutritionalController
    }

    func boot(routes: RoutesBuilder) throws {
        let productRoutes = routes.grouped("productList")
        productRoutes.get(use: getProductList)
        //productRoutes.get("/:id", use: getProduct)
        productRoutes.post(use: createNewProduct)
        productRoutes.put(use: updateProduct)
        productRoutes.delete(use: deleteProduct)
    }

    private func getProductList(req: Request) async throws -> APIProductListResponse {
        let result = try await productRepository.getProductList()
        let products = result.map { APIProductResponse(from: $0) }
        return APIProductListResponse(count: products.count, products: products)
    }

    private func getProduct(req: Request) async throws -> APIProductResponse {
        guard let id = req.parameters.get("id") else {
            throw Abort(.badRequest, reason: APIErrorMessage.Common.badRequest)
        }

        guard let product = try await productRepository.getProduct(with: id) else {
            throw Abort(.notFound, reason: APIErrorMessage.Common.notFound)
        }

        return APIProductResponse(from: product)
    }

    private func createNewProduct(req: Request) async throws -> APIGenericMessageResponse {
        // check user privilegies
        let model: APIProductModel = try convertRequestDataToModel(req: req)

        guard try await productRepository.getProduct(with: model.id) == nil else {
            throw Abort(.conflict, reason: APIErrorMessage.Common.conflict)
        }

        for tag in model.tags {
            guard try await tagsRepository.getTag(with: tag.code) != nil else {
                throw Abort(.badRequest, reason: APIErrorMessage.Product.invalidProductTag)
            }
        }

        for tag in model.allergicTags {
            guard try await tagsRepository.getTag(with: tag.code) != nil else {
                throw Abort(.badRequest, reason: APIErrorMessage.Product.invalidProductTag)
            }
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
