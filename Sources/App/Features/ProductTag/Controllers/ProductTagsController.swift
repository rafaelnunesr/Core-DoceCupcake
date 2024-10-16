import FluentPostgresDriver
import Foundation
import Vapor

protocol ProductTagsControllerProtocol: RouteCollection, Sendable {
    func areTagCodesValid(_ tagCodeList: [String]) async throws -> Bool
    func fetchTags(_ tagCodeList: [String]) async throws -> [ProductTag]
}

struct ProductTagsController: ProductTagsControllerProtocol {
    private let repository: RepositoryProtocol
    private let security: SecurityProtocol
    
    private let userSectionValidation: SessionValidationMiddlewareProtocol
    private let adminSectionValidation: AdminValidationMiddlewareProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: RepositoryProtocol) {
        self.repository = repository
        userSectionValidation = dependencyProvider.getUserSessionValidationMiddleware()
        adminSectionValidation = dependencyProvider.getAdminSessionValidationMiddleware()
        security = dependencyProvider.getSecurityInstance()
    }

    func boot(routes: RoutesBuilder) throws {
        let productRoutes = routes.grouped(PathRoutes.productTags.path)
        
        productRoutes
            .grouped(userSectionValidation)
            .get(use: fetchProductTags)
        
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
    private func fetchProductTags(req: Request) async throws -> ProductTagListResponse {
        let result: [ProductTag] = try await repository.fetchAllResults()
        let tags = result.map { APIProductTag(from: $0) }
        return ProductTagListResponse(count: tags.count, tags: tags)
    }
    
    @Sendable
    private func create(req: Request) async throws -> GenericMessageResponse {
        let models: [APIProductTag] = try req.content.decode([APIProductTag].self)
        
        for model in models {
            guard try await fetchTag(with: model.code) == nil else {
                throw APIResponseError.Common.conflict
            }
            
            try await repository.create(ProductTag(from: model))
        }
        
        return GenericMessageResponse(message: "Tag created")
    }
    
    @Sendable
    private func update(req: Request) async throws -> GenericMessageResponse {
        let model: APIProductTag = try convertRequestDataToModel(req: req)

        guard let productTag = try await fetchTag(with: model.code) else {
            throw APIResponseError.Common.notFound
        }

        productTag.description = model.description
        try await repository.update(productTag)

        return GenericMessageResponse(message: Constants.tagUpdated)
    }

    @Sendable
    private func delete(req: Request) async throws -> GenericMessageResponse {
        let model: APIRequestCode = try convertRequestDataToModel(req: req)

        guard let tagModel = try await fetchTag(with: model.code) else {
            throw APIResponseError.Common.notFound
        }

        try await repository.delete(tagModel)

        return GenericMessageResponse(message: Constants.tagDeleted)
    }

    private func fetchTag(with code: String) async throws -> ProductTag? {
        let result: ProductTag? = try await repository.fetchModelByCode(code)
        return result
    }

    func areTagCodesValid(_ tagCodeList: [String]) async throws -> Bool {
        for code in tagCodeList {
            guard try await fetchTag(with: code) != nil else {
                return false
            }
        }

        return true
    }

    func fetchTags(_ tagCodeList: [String]) async throws -> [ProductTag] {
        var tagModels = [ProductTag]()

        for code in tagCodeList {
            if let result = try await fetchTag(with: code) {
                tagModels.append(result)
            }
        }

        return tagModels
    }

    enum Constants {
        static let tagCreated = "Tag created"
        static let tagUpdated = "Tag updated"
        static let tagDeleted = "Tag deleted"
    }
}
