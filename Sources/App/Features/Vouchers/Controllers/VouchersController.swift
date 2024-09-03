import FluentPostgresDriver
import Vapor

protocol VouchersControllerProtocol: RouteCollection {
    func getVoucher(with code: String) async throws -> Voucher?
}

struct VouchersController: VouchersControllerProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: RepositoryProtocol
    
    private let adminSectionValidation: AdminValidationMiddlewareProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: RepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
        
        adminSectionValidation = dependencyProvider.getAdminSectionValidationMiddleware()
    }

    func boot(routes: RoutesBuilder) throws {
        let vouchersRoutes = routes.grouped(Routes.vouchers.pathValue)
            .grouped(adminSectionValidation)
        
        vouchersRoutes.get(use: getVouchersList)
        vouchersRoutes.post(use: createVoucher)
        vouchersRoutes.delete(use: deleteVoucher)
    }

    private func getVouchersList(req: Request) async throws -> APIVoucherModelList {
        let result: [Voucher] = try await repository.fetchAllResults()
        let vouchers = result.map { APIVoucher(from: $0) }
        return APIVoucherModelList(count: vouchers.count, vouchers: vouchers)
    }

    private func createVoucher(req: Request) async throws -> GenericMessageResponse {
        let model: APIVoucher = try convertRequestDataToModel(req: req)

        guard try await getVoucher(with: model.code) == nil else {
            throw Abort(.conflict, reason: APIErrorMessage.Common.conflict)
        }

        try await repository.create(Voucher(from: model))

        return GenericMessageResponse(message: Constants.voucherCreated)
    }

    private func deleteVoucher(req: Request) async throws -> GenericMessageResponse {
        let model: APIDeleteInfo = try convertRequestDataToModel(req: req)

        guard let voucher = try await getVoucher(with: model.id) else {
            throw Abort(.notFound, reason: APIErrorMessage.Common.notFound)
        }

        try await repository.delete(voucher)

        return GenericMessageResponse(message: Constants.voucherDeleted)
    }


    func getVoucher(with code: String) async throws -> Voucher? {
        try await repository.fetchModelByCode(code)
    }


    private enum Constants {
        static let voucherCreated = "Voucher created."
        static let voucherDeleted = "Voucher deleted."
    }
}
