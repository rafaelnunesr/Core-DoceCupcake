import FluentPostgresDriver
import Vapor

protocol PackagingControllerProtocol: RouteCollection, Sendable {
    func getPackage(with code: String) async throws -> Package?
}

struct PackagingController: PackagingControllerProtocol {
    private let repository: RepositoryProtocol
    
    private let userSectionValidation: SessionValidationMiddlewareProtocol
    private let adminSectionValidation: AdminValidationMiddlewareProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: RepositoryProtocol) {
        self.repository = repository
        userSectionValidation = dependencyProvider.getUserSessionValidationMiddleware()
        adminSectionValidation = dependencyProvider.getAdminSessionValidationMiddleware()
    }

    func boot(routes: RoutesBuilder) throws {
        let packageRoutes = routes.grouped(PathRoutes.packages.path)
        
        packageRoutes
            .grouped(userSectionValidation)
            .get(use: getPackageList)
        
        packageRoutes
            .grouped(adminSectionValidation)
            .post(use: createPackage)
        
        packageRoutes
            .grouped(adminSectionValidation)
            .delete(use: deletePackage)
    }

    @Sendable
    private func getPackageList(req: Request) async throws -> APIPackageList {
        let result: [Package] = try await repository.fetchAllResults()
        let packages = result.map { APIPackage(from: $0) }
        return APIPackageList(count: packages.count, package: packages)
    }
    
    @Sendable
    private func createPackage(req: Request) async throws -> GenericMessageResponse {
        let models: [APIPackage] = try req.content.decode([APIPackage].self)
        
        for model in models {
            guard try await getPackage(with: model.code) == nil else {
                throw APIResponseError.Common.conflict
            }
            
            try await repository.create(Package(from: model))
        }
        
        return GenericMessageResponse(message: "Package created")
    }
    
    @Sendable
    private func deletePackage(req: Request) async throws -> GenericMessageResponse {
        let model: APIRequestId = try convertRequestDataToModel(req: req)

        guard let package = try await getPackage(with: model.id) 
        else { throw APIResponseError.Common.notFound }

        try await repository.delete(package)

        return GenericMessageResponse(message: Constants.packageDeleted)
    }

    func getPackage(with code: String) async throws -> Package? {
        let result: Package? = try await repository.fetchModelByCode(code)
        return result
    }

    enum Constants {
        static let packageCreated = "Package created."
        static let packageDeleted = "Package deleted."
    }
}
