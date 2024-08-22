import FluentPostgresDriver
import Foundation
import Vapor

struct ProductController: RouteCollection {
    private let dependencyProvider: DependencyProviderProtocol
    private let productRepository: ProductRepositoryProtocol
    private let tagsRepository: ProductTagsRepositoryProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         productRepository: ProductRepositoryProtocol,
         tagsRepository: ProductTagsRepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.productRepository = productRepository
        self.tagsRepository = tagsRepository
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

        for tagCode in model.tags {
            guard try await tagsRepository.getTag(with: tagCode) != nil else {
                throw Abort(.badRequest, reason: APIErrorMessage.Common.badRequest)
            }
        }

        for allergicTagCode in model.allergicTags {
            guard try await tagsRepository.getTag(with: allergicTagCode) != nil else {
                throw Abort(.badRequest, reason: APIErrorMessage.Common.badRequest)
            }
        }

        try await productRepository.createProduct(InternalProductModel(from: model))

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
