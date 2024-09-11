import FluentPostgresDriver
import Vapor

protocol VouchersControllerProtocol: RouteCollection, Sendable {
    func getVoucher(with code: String) async throws -> Voucher?
}

struct VouchersController: VouchersControllerProtocol {
    private let dependencyProvider: DependencyProviderProtocol
    private let repository: RepositoryProtocol
    
    private let sessionValidation: SessionValidationMiddlewareProtocol
    private let adminSectionValidation: AdminValidationMiddlewareProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: RepositoryProtocol) {
        self.dependencyProvider = dependencyProvider
        self.repository = repository
        
        sessionValidation = dependencyProvider.getUserSessionValidationMiddleware()
        adminSectionValidation = dependencyProvider.getAdminSessionValidationMiddleware()
    }

    func boot(routes: RoutesBuilder) throws {
        let vouchersRoutes = routes.grouped(PathRoutes.vouchers.path)
            
        vouchersRoutes
            .grouped(sessionValidation)
            .get(use: getVoucher)
        
        vouchersRoutes
            .grouped(adminSectionValidation)
            .get("/all", use: getVouchersList)
        
        vouchersRoutes
            .grouped(adminSectionValidation)
            .post(use: createVoucher)
        
        vouchersRoutes
            .grouped(adminSectionValidation)
            .delete(use: deleteVoucher)
    }
    
    @Sendable
    private func getVoucher(req: Request) async throws -> APIValidateVoucher {
        let model: APIValidateVoucher = try convertRequestDataToModel(req: req)
        let result: Voucher? = try await repository.fetchModelByCode(model.code)
        
        guard let result else {
            throw Abort(.notFound, reason: APIErrorMessage.Common.notFound)
        }
        
        return APIValidateVoucher(from: result)
    }
    
    @Sendable
    private func getVouchersList(req: Request) async throws -> APIVoucherModelList {
        let result: [Voucher] = try await repository.fetchAllResults()
        let vouchers = result.map { APIVoucher(from: $0) }
        return APIVoucherModelList(count: vouchers.count, vouchers: vouchers)
    }

    @Sendable
    private func createVoucher(req: Request) async throws -> GenericMessageResponse {
        let model: APIVoucher = try convertRequestDataToModel(req: req)

        guard try await getVoucher(with: model.code) == nil else {
            throw Abort(.conflict, reason: APIErrorMessage.Common.conflict)
        }

        try await repository.create(Voucher(from: model))

        return GenericMessageResponse(message: Constants.voucherCreated)
    }

    @Sendable
    private func deleteVoucher(req: Request) async throws -> GenericMessageResponse {
        let model: APIRequestId = try convertRequestDataToModel(req: req)

        guard let voucher = try await getVoucher(with: model.id) else {
            throw Abort(.notFound, reason: APIErrorMessage.Common.notFound)
        }

        try await repository.delete(voucher)

        return GenericMessageResponse(message: Constants.voucherDeleted)
    }

    func getVoucher(with code: String) async throws -> Voucher? {
        try await repository.fetchModelByCode(code)
    }

    enum Constants {
        static let voucherCreated = "Voucher created."
        static let voucherDeleted = "Voucher deleted."
    }
}
