import FluentPostgresDriver
import Vapor

protocol PackagingRepositoryProtocol {
    func getAllPackages() async throws -> [InternalPackageModel]
    func getPackageByCode(_ code: String) async throws -> InternalPackageModel?
    func createPackage(_ package: InternalPackageModel) async throws
    func deletePackage(_ package: InternalPackageModel) async throws
}

final class PackagingRepository: PackagingRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }

    func getAllPackages() async throws -> [InternalPackageModel] {
        try await InternalPackageModel.query(on: database)
            .all()
    }

    func getPackageByCode(_ code: String) async throws -> InternalPackageModel? {
        try await InternalPackageModel.query(on: database)
            .filter(\.$code == code)
            .first()
    }

    func createPackage(_ package: InternalPackageModel) async throws {
        try await package.create(on: database)
    }


    func deletePackage(_ package: InternalPackageModel) async throws {
        try await package.delete(on: database)
    }
}
