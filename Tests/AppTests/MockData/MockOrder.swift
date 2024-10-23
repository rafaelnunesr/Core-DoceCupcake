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
                       orderStatus: Int = 1,
                       discount: Double = 1,
                       subtotal: Double = 1) -> Order {
        Order(id: id,
              number: number,
              createdAt: createdAt,
              updatedAt: updatedAt,
              userId: userId,
              voucherCode: voucherCode,
              paymentId: paymentId,
              total: total,
              discount: discount,
              subtotal: subtotal,
              deliveryFee: deliveryFee,
              addressId: addressId,
              orderStatus: orderStatus)
    }
    
    var orderA = create()
}
