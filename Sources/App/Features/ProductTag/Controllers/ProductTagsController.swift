import FluentPostgresDriver
import Foundation
import Vapor

protocol ProductTagsControllerProtocol: RouteCollection {
    func areTagCodesValid(_ tagCodeList: [String]) async throws -> Bool
    func getTagsFor(_ tagCodeList: [String]) async throws -> [InternalProductTagModel]
}

struct ProductTagsController: ProductTagsControllerProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: ProductTagsRepositoryProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: ProductTagsRepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
    }

    func boot(routes: RoutesBuilder) throws {
        let productRoutes = routes.grouped("productTags")
        productRoutes.get(use: getProductTagsList)
        productRoutes.post(use: createNewTag)
        productRoutes.delete(use: deleteTag)
    }

    private func getProductTagsList(req: Request) async throws -> APIProductTagListResponse {
        // check user privilegies
        let result = try await repository.getAllTags()
        let tags = result.map { APIProductTagModel(from: $0) }
        return APIProductTagListResponse(count: tags.count, tags: tags)
    }

    private func createNewTag(req: Request) async throws -> APIGenericMessageResponse {
        // check user privilegies
        let model: APIProductTagModel = try convertRequestDataToModel(req: req)

        guard try await repository.getTag(with: model.code) == nil else {
            throw Abort(.conflict, reason: APIErrorMessage.Common.conflict)
        }

        try await repository.createNewTag(InternalProductTagModel(from: model))

        return APIGenericMessageResponse(message: Constants.tagCreated)
    }

    private func deleteTag(req: Request) async throws -> APIGenericMessageResponse {
        // check user privilegies
        let model: APIDeleteInfo = try convertRequestDataToModel(req: req)

        guard let tagModel = try await repository.getTag(with: model.id) else {
            throw Abort(.notFound, reason: APIErrorMessage.Common.notFound)
        }

        try await repository.deleteTag(tagModel)

        return APIGenericMessageResponse(message: Constants.tagDeleted)
    }

    func areTagCodesValid(_ tagCodeList: [String]) async throws -> Bool {
        for code in tagCodeList {
            guard try await repository.getTag(with: code) != nil else {
                return false
            }
        }

        return true
    }

    func getTagsFor(_ tagCodeList: [String]) async throws -> [InternalProductTagModel] {
        var tagModels = [InternalProductTagModel]()

        for code in tagCodeList {
            if let result = try await repository.getTag(with: code) {
                tagModels.append(result)
            }
        }

        return tagModels
    }

    private enum Constants {
        static let tagCreated = "Tag created"
        static let tagDeleted = "Tag deleted"
    }
}
