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
            .get(use: fetchVoucher)
        
        vouchersRoutes
            .grouped(adminSectionValidation)
            .get("/all", use: fetchVouchers)
        
        vouchersRoutes
            .grouped(adminSectionValidation)
            .post(use: create)
        
        vouchersRoutes
            .grouped(adminSectionValidation)
            .delete(use: delete)
    }
    
    @Sendable
    private func fetchVoucher(req: Request) async throws -> APIValidateVoucherResponse {
        let model: APIRequestCode = try convertRequestDataToModel(req: req)
        let result: Voucher? = try await repository.fetchModelByCode(model.code)
        
        guard let result else {
            throw APIError.notFound
        }
        
        return APIValidateVoucherResponse(from: result)
    }
    
    @Sendable
    private func fetchVouchers(req: Request) async throws -> APIVoucherListResponse {
        let result: [Voucher] = try await repository.fetchAllResults()
        let vouchers = result.map { APIVoucher(from: $0) }
        return APIVoucherListResponse(count: vouchers.count, vouchers: vouchers)
    }

    @Sendable
    private func create(req: Request) async throws -> GenericMessageResponse {
        let model: APIVoucher = try convertRequestDataToModel(req: req)

        guard try await getVoucher(with: model.code) == nil else {
            throw APIError.conflict
        }

        try await repository.create(Voucher(from: model))

        return GenericMessageResponse(message: createVoucherSuccessMessage(voucherCode: model.code))
    }

    @Sendable
    private func delete(req: Request) async throws -> GenericMessageResponse {
        let model: APIRequestCode = try convertRequestDataToModel(req: req)

        guard let voucher = try await getVoucher(with: model.code) else {
            throw APIError.notFound
        }

        try await repository.delete(voucher)

        return GenericMessageResponse(message: deleteVoucherSuccessMessage(voucherCode: model.code))
    }

    func getVoucher(with code: String) async throws -> Voucher? {
        try await repository.fetchModelByCode(code)
    }
    
    private func createVoucherSuccessMessage(voucherCode: String) -> String {
        "The voucher with the code \(voucherCode) has been created successfully."
    }
    
    private func deleteVoucherSuccessMessage(voucherCode: String) -> String {
        "The voucher with the code \(voucherCode) has been deleted successfully."
    }
}
