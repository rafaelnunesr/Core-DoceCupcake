import Fluent

struct CreateReviewMigration: AsyncMigration {
    private let databaseName = ReviewDbField.schema.rawValue

    func prepare(on database: Database) async throws {
        try await database.schema(databaseName)
            .id()
            .field(ReviewDbField.createdAt.fieldKey, .datetime)
            .field(ReviewDbField.orderId.fieldKey, .uuid, .required,
                .references(OrderDbField.schema.rawValue, OrderDbField.id.fieldKey))
            .field(ReviewDbField.userId.fieldKey, .uuid, .required,
                   .references(UsersDbField.schema.rawValue, UsersDbField.id.fieldKey))
            .field(ReviewDbField.productId.fieldKey, .uuid, .required,
                   .references(ProductDbField.schema.rawValue, ProductDbField.id.fieldKey))
            .field(ReviewDbField.userName.fieldKey, .string, .required)
            .field(ReviewDbField.rate.fieldKey, .int, .required)
            .field(ReviewDbField.title.fieldKey, .string, .required)
            .field(ReviewDbField.text.fieldKey, .string, .required)
            .constraint(.custom("CHECK (\(ReviewDbField.rate.rawValue) BETWEEN 1 AND 5)"))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(databaseName).delete()
    }
}
