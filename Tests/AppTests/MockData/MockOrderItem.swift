import Foundation

@testable import App

struct MockOrderItem {
    static func create(id: UUID? = UUID(),
                       orderId: UUID = UUID(),
                       productId: UUID = UUID(),
                       quantity: Double = 1,
                       unitValue: Double = 1,
                       orderStatus: Int = 1) -> OrderItem {
        OrderItem(id: id,
                  orderId: orderId,
                  productId: productId,
                  quantity: quantity,
                  unitValue: unitValue,
                  orderStatus: orderStatus)
    }
    
    var itemA = create()
    var itemB = create()
}
