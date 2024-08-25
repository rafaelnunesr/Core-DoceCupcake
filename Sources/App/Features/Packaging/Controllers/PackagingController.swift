import FluentPostgresDriver
import Vapor

protocol PackagingControllerProtocol: RouteCollection {

}

struct PackagingController: PackagingControllerProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: PackagingRepositoryProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: PackagingRepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
    }

    func boot(routes: RoutesBuilder) throws {
        let packageRoutes = routes.grouped("packages")
        packageRoutes.get(use: getPackageList)
        packageRoutes.post(use: createPackage)
        packageRoutes.delete(use: deletePackage)
    }

    private func getPackageList(req: Request) async throws -> APIPackageList {
        // check user privilegies
        let result = try await repository.getAllPackages()
        let packages = result.map { APIPackage(from: $0) }
        return APIPackageList(count: packages.count, package: packages)
    }

    private func createPackage(req: Request) async throws -> APIGenericMessageResponse {
        // check user privilegies
        let model: APIPackage = try convertRequestDataToModel(req: req)

        guard try await getPackage(with: model.code) == nil else {
            throw Abort(.conflict, reason: APIErrorMessage.Common.conflict)
        }

        try await repository.createPackage(InternalPackageModel(from: model))

        return APIGenericMessageResponse(message: Constants.packageCreated)
    }

    private func deletePackage(req: Request) async throws -> APIGenericMessageResponse {
        // check user privilegies
        let model: APIDeleteInfo = try convertRequestDataToModel(req: req)

        guard let package = try await getPackage(with: model.id) else {
            throw Abort(.notFound, reason: APIErrorMessage.Common.notFound)
        }

        try await repository.deletePackage(package)

        return APIGenericMessageResponse(message: Constants.packageDeleted)
    }


    func getPackage(with code: String) async throws -> InternalPackageModel? {
        try await repository.getPackageByCode(code)
    }


    private enum Constants {
        static let packageCreated = "Package created."
        static let packageDeleted = "Package deleted."
    }
}
