import FluentPostgresDriver
import Vapor

protocol VouchersControllerProtocol: RouteCollection {
    func getVoucher(with code: String) async throws -> InternalVoucherModel?
}

struct VouchersController: VouchersControllerProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: VouchersRepositoryProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: VouchersRepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
    }

    func boot(routes: RoutesBuilder) throws {
        let vouchersRoutes = routes.grouped("vouchers")
        vouchersRoutes.get(use: getVouchersList)
        vouchersRoutes.post(use: createVoucher)
        vouchersRoutes.delete(use: deleteVoucher)
    }

    private func getVouchersList(req: Request) async throws -> APIVoucherModelList {
        // check user privilegies
        let result = try await repository.getAllVouchers()
        let vouchers = result.map { APIVoucherModel(from: $0) }
        return APIVoucherModelList(count: vouchers.count, vouchers: vouchers)
    }

    private func createVoucher(req: Request) async throws -> APIGenericMessageResponse {
        // check user privilegies
        let model: APIVoucherModel = try convertRequestDataToModel(req: req)

        guard try await getVoucher(with: model.code) == nil else {
            throw Abort(.conflict, reason: APIErrorMessage.Common.conflict)
        }

        try await repository.createVoucher(InternalVoucherModel(from: model))

        return APIGenericMessageResponse(message: Constants.voucherCreated)
    }

    private func deleteVoucher(req: Request) async throws -> APIGenericMessageResponse {
        // check user privilegies
        let model: APIDeleteInfo = try convertRequestDataToModel(req: req)

        guard let voucher = try await getVoucher(with: model.id) else {
            throw Abort(.notFound, reason: APIErrorMessage.Common.notFound)
        }

        try await repository.deleteVoucher(voucher)

        return APIGenericMessageResponse(message: Constants.voucherDeleted)
    }


    func getVoucher(with code: String) async throws -> InternalVoucherModel? {
        try await repository.getVoucherByCode(code)
    }


    private enum Constants {
        static let voucherCreated = "Voucher created."
        static let voucherDeleted = "Voucher deleted."
    }
}
