import Vapor

protocol VouchersControllerProtocol: RouteCollection, Sendable {
    func getVoucher(with code: String) async throws -> Voucher?
    func applyVoucher(_ value: Double, voucherCode: String) async throws -> Double
}

struct VouchersController: VouchersControllerProtocol {
    private let repository: RepositoryProtocol
    
    private let sessionValidation: SessionValidationMiddlewareProtocol
    private let adminSectionValidation: AdminValidationMiddlewareProtocol

    init(dependencyProvider: DependencyProviderProtocol,
         repository: RepositoryProtocol) {
        self.repository = repository
        
        sessionValidation = dependencyProvider.getUserSessionValidationMiddleware()
        adminSectionValidation = dependencyProvider.getAdminSessionValidationMiddleware()
    }

    func boot(routes: RoutesBuilder) throws {
        let vouchersRoutes = routes.grouped(PathRoutes.vouchers.path)
        
        vouchersRoutes
            .grouped(sessionValidation)
            .get(":voucherCode", use: fetchVoucher)
        
        vouchersRoutes
            .grouped(adminSectionValidation)
            .get("all", use: fetchVouchers)
        
        vouchersRoutes
            .grouped(adminSectionValidation)
            .post(use: create)
        
        vouchersRoutes
            .grouped(adminSectionValidation)
            .delete(use: delete)
    }
    
    @Sendable
    private func fetchVoucher(req: Request) async throws -> APIValidateVoucherResponse {
        guard let voucherCode = req.parameters.get("voucherCode")
        else { throw APIResponseError.Common.badRequest }

        let result: Voucher? = try await repository.fetchModelByCode(voucherCode)
        
        guard let result 
        else { throw APIResponseError.Common.notFound }
        
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

        guard try await getVoucher(with: model.code) == nil 
        else { throw APIResponseError.Common.conflict }

        try await repository.create(Voucher(from: model))

        return GenericMessageResponse(message: createVoucherSuccessMessage(voucherCode: model.code))
    }

    @Sendable
    private func delete(req: Request) async throws -> GenericMessageResponse {
        let model: APIRequestCode = try convertRequestDataToModel(req: req)

        guard let voucher = try await getVoucher(with: model.code)
        else { throw APIResponseError.Common.notFound }

        try await repository.delete(voucher)

        return GenericMessageResponse(message: deleteVoucherSuccessMessage(voucherCode: model.code))
    }

    func getVoucher(with code: String) async throws -> Voucher? {
        try await repository.fetchModelByCode(code)
    }
    
    func applyVoucher(_ value: Double, voucherCode: String) async throws -> Double {
        if let voucher: Voucher = try await repository.fetchModelByCode(voucherCode) {
            if let monetaryValue = voucher.monetaryDiscount {
                try await updateVouchersAvailability(voucher)
                return monetaryValue
            }
            
            if let percentageDiscount = voucher.percentageDiscount {
                try await updateVouchersAvailability(voucher)
                return value * (percentageDiscount / 100)
            }
        }
        
        return .zero
    }
    
    private func updateVouchersAvailability(_ voucher: Voucher) async throws {
        let copyVoucher = voucher
        if let count = copyVoucher.availabilityCount, count > .zero {
            copyVoucher.availabilityCount = count - 1
            try await repository.update(copyVoucher)
        }
    }
    
    private func createVoucherSuccessMessage(voucherCode: String) -> String {
        "The voucher with the code \(voucherCode) has been created successfully."
    }
    
    private func deleteVoucherSuccessMessage(voucherCode: String) -> String {
        "The voucher with the code \(voucherCode) has been deleted successfully."
    }
}
