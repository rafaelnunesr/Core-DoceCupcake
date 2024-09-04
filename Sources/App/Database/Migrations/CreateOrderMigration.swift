//import Fluent
//
//struct CreateOrderMigration: AsyncMigration {
//    private let databaseName = OrderDbField.schema.rawValue
//    
//    func prepare(on database: Database) async throws {
//        try await database.schema(databaseName)
//            .id()
//            .field(OrderDbField.createdAt.fieldKey,
//                   .datetime)
//            .field(OrderDbField.updatedAt.fieldKey,
//                   .datetime)
//            .field(OrderDbField.userId.fieldKey,
//                   .uuid,
//                   .required,
//                   .references(UsersDbField.schema.rawValue,
//                               UsersDbField.id.fieldKey))
//            .field(OrderDbField.voucherId.fieldKey,
//                   .uuid,
//                   .references(VoucherDbField.schema.rawValue,
//                               VoucherDbField.id.fieldKey))
//            .field(OrderDbField.paymentId.fieldKey,
//                .uuid,
//                .required,
//                   .references(CreditCardDbField.schema.rawValue,
//                               CreditCardDbField.id.fieldKey))
//            .field(OrderDbField.addressId.fieldKey,
//                .uuid,
//                .required,
//                   .references(AddressDbField.schema.rawValue,
//                               AddressDbField.id.fieldKey))
//            .field(OrderDbField.deliveryStatus.fieldKey,
//                .string,
//                   .required)
//            .field(OrderDbField.orderStatus.fieldKey,
//                .string,
//                   .required)
//            .create()
//    }
//    
//    func revert(on database: Database) async throws {
//        try await database.schema(databaseName).delete()
//    }
//}
