import Vapor

@testable import App

struct MockVouchersController: VouchersControllerProtocol {
    func boot(routes: RoutesBuilder) throws {}
    
    func getVoucher(with code: String) async throws -> Voucher? {
        nil
    }
    
    func applyVoucher(_ value: Double, voucherCode: String) async throws -> Double {
        .zero
    }
    
    func applyVoucher(_ value: Double, voucherCode: String) async throws {}
    
    func calculateVoucherDiscount(_ value: Double, voucher: Voucher) async throws -> Double {
        .zero
    }
}
