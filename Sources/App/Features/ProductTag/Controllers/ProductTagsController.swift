import FluentPostgresDriver
import Foundation
import Vapor

protocol ProductTagsControllerProtocol: RouteCollection {
    func areTagCodesValid(_ tagCodeList: [String]) async throws -> Bool
    func getTagsFor(_ tagCodeList: [String]) async throws -> [InternalProductTagModel]
}

struct ProductTagsController: ProductTagsControllerProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: RepositoryProtocol
    private let sectionController: SectionControllerProtocol
    private let security: SecurityProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: RepositoryProtocol,
         sectionController: SectionControllerProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
        self.sectionController = sectionController
        
        security = dependencyProvider.getSecurityInstance()
    }

    func boot(routes: RoutesBuilder) throws {
        let productRoutes = routes.grouped("productTags")
        productRoutes.get(use: getProductTagsList)
        productRoutes.post(use: createNewTag)
        productRoutes.delete(use: deleteTag)
    }
    
    private func getProductTagsList(req: Request) async throws -> APIProductTagListResponse {
        guard try await sectionController.validateSection(req: req) != nil else {
            throw Abort(.unauthorized, reason: "unauthorized")
        }
        
        let result: [InternalProductTagModel] = try await repository.fetchAllResults()
        let tags = result.map { APIProductTagModel(from: $0) }
        return APIProductTagListResponse(count: tags.count, tags: tags)
    }

    private func createNewTag(req: Request) async throws -> APIGenericMessageResponse {
        guard let section = try await sectionController.validateSection(req: req),
              section.isAdmin else {
            throw Abort(.unauthorized, reason: "unauthorized")
        }
        
        let model: APIProductTagModel = try convertRequestDataToModel(req: req)

        guard try await getTag(with: model.code) == nil else {
            throw Abort(.conflict, reason: APIErrorMessage.Common.conflict)
        }

        try await repository.create(InternalProductTagModel(from: model))

        return APIGenericMessageResponse(message: Constants.tagCreated)
    }

    private func deleteTag(req: Request) async throws -> APIGenericMessageResponse {
        guard let section = try await sectionController.validateSection(req: req),
              section.isAdmin else {
            throw Abort(.unauthorized, reason: "unauthorized")
        }
        
        let model: APIDeleteInfo = try convertRequestDataToModel(req: req)

        guard let tagModel = try await getTag(with: model.id) else {
            throw Abort(.notFound, reason: APIErrorMessage.Common.notFound)
        }

        try await repository.delete(tagModel)

        return APIGenericMessageResponse(message: Constants.tagDeleted)
    }

    private func getTag(with code: String) async throws -> InternalProductTagModel? {
        let result: InternalProductTagModel? = try await repository.fetchModelByCode(code)
        return result
    }

    func areTagCodesValid(_ tagCodeList: [String]) async throws -> Bool {
        for code in tagCodeList {
            guard try await getTag(with: code) != nil else {
                return false
            }
        }

        return true
    }

    func getTagsFor(_ tagCodeList: [String]) async throws -> [InternalProductTagModel] {
        var tagModels = [InternalProductTagModel]()

        for code in tagCodeList {
            if let result = try await getTag(with: code) {
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
