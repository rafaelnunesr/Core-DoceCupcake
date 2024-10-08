import Foundation

@testable import App

struct MockOrder {
    static func create(id: UUID? = UUID(),
                       number: String = "1",
                       createdAt: Date? = Date(),
                       updatedAt: Date? = Date(),
                       userId: UUID = UUID(),
                       voucherCode: String? = nil,
                       paymentId: UUID = UUID(),
                       total: Double = 1,
                       deliveryFee: Double = 1,
                       addressId: UUID = UUID(),
                       deliveryStatus: Int = 1,
                       orderStatus: Int = 1) -> Order {
        Order(id: id,
              number: number,
              userId: userId,
              voucherCode: voucherCode,
              paymentId: paymentId,
              total: total,
              deliveryFee: deliveryFee,
              addressId: addressId,
              deliveryStatus: deliveryStatus,
              orderStatus: orderStatus)
    }
    
    var orderA = create()
}
