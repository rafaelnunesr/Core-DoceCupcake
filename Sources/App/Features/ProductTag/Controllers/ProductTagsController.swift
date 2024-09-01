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
    private let security: SecurityProtocol
    
    private let userSectionValidation: SectionValidationMiddlewareProtocol
    private let adminSectionValidation: AdminValidationMiddlewareProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: RepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
        
        userSectionValidation = dependencyProvider.getUserSectionValidationMiddleware()
        adminSectionValidation = dependencyProvider.getAdminSectionValidationMiddleware()
        security = dependencyProvider.getSecurityInstance()
    }

    func boot(routes: RoutesBuilder) throws {
        let productRoutes = routes.grouped("productTags")
        productRoutes
            .grouped(userSectionValidation)
            .get(use: getProductTagsList)
        
        productRoutes
            .grouped(adminSectionValidation)
            .post(use: createNewTag)
        
        productRoutes
            .grouped(adminSectionValidation)
            .delete(use: deleteTag)
    }
    
    private func getProductTagsList(req: Request) async throws -> APIProductTagListResponse {
        let result: [InternalProductTagModel] = try await repository.fetchAllResults()
        let tags = result.map { APIProductTagModel(from: $0) }
        return APIProductTagListResponse(count: tags.count, tags: tags)
    }

    private func createNewTag(req: Request) async throws -> APIGenericMessageResponse {
        let model: APIProductTagModel = try convertRequestDataToModel(req: req)

        guard try await getTag(with: model.code) == nil else {
            throw Abort(.conflict, reason: APIErrorMessage.Common.conflict)
        }

        try await repository.create(InternalProductTagModel(from: model))

        return APIGenericMessageResponse(message: Constants.tagCreated)
    }

    private func deleteTag(req: Request) async throws -> APIGenericMessageResponse {
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
