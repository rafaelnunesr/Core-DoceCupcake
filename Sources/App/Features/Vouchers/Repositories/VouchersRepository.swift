import FluentPostgresDriver
import Vapor

protocol VouchersRepositoryProtocol {
    func getAllVouchers() async throws -> [InternalVoucherModel]
    func getVoucherByCode(_ code: String) async throws -> InternalVoucherModel?
    func createVoucher(_ voucher: InternalVoucherModel) async throws
    func deleteVoucher(_ voucher: InternalVoucherModel) async throws
}

final class VouchersRepository: VouchersRepositoryProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let database: Database

    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
        database = dependencyProvider.getDatabaseInstance()
    }

    func getAllVouchers() async throws -> [InternalVoucherModel] {
        try await InternalVoucherModel.query(on: database)
            .all()
    }

    func getVoucherByCode(_ code: String) async throws -> InternalVoucherModel? {
        try await InternalVoucherModel.query(on: database)
            .filter(\.$code == code)
            .first()
    }

    func createVoucher(_ voucher: InternalVoucherModel) async throws {
        try await voucher.create(on: database)
    }

    func deleteVoucher(_ voucher: InternalVoucherModel) async throws {
        try await voucher.delete(on: database)
    }
}
