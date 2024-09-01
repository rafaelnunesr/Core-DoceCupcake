import FluentPostgresDriver
import Vapor

protocol PackagingControllerProtocol: RouteCollection {
    func getPackage(with code: String) async throws -> InternalPackageModel?
}

struct PackagingController: PackagingControllerProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: RepositoryProtocol
    
    private let userSectionValidation: SectionValidationMiddlewareProtocol
    private let adminSectionValidation: AdminValidationMiddlewareProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: RepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
        
        userSectionValidation = dependencyProvider.getUserSectionValidationMiddleware()
        adminSectionValidation = dependencyProvider.getAdminSectionValidationMiddleware()
    }

    func boot(routes: RoutesBuilder) throws {
        let packageRoutes = routes.grouped("packages")
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

    private func getPackageList(req: Request) async throws -> APIPackageList {
        let result: [InternalPackageModel] = try await repository.fetchAllResults()
        let packages = result.map { APIPackage(from: $0) }
        return APIPackageList(count: packages.count, package: packages)
    }

    private func createPackage(req: Request) async throws -> APIGenericMessageResponse {
        let model: APIPackage = try convertRequestDataToModel(req: req)

        guard try await getPackage(with: model.code) == nil else {
            throw Abort(.conflict, reason: APIErrorMessage.Common.conflict)
        }

        try await repository.create(InternalPackageModel(from: model))

        return APIGenericMessageResponse(message: Constants.packageCreated)
    }

    private func deletePackage(req: Request) async throws -> APIGenericMessageResponse {
        let model: APIDeleteInfo = try convertRequestDataToModel(req: req)

        guard let package = try await getPackage(with: model.id) else {
            throw Abort(.notFound, reason: APIErrorMessage.Common.notFound)
        }

        try await repository.delete(package)

        return APIGenericMessageResponse(message: Constants.packageDeleted)
    }

    func getPackage(with code: String) async throws -> InternalPackageModel? {
        let result: InternalPackageModel? = try await repository.fetchModelByCode(code)
        return result
    }


    private enum Constants {
        static let packageCreated = "Package created."
        static let packageDeleted = "Package deleted."
    }
}