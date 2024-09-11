extension APIErrorMessage {
    enum Common {
        static let badRequest = "Bad request"
        static let conflict = "Duplicated data"
        static let notFound = "No data found"
        static let unauthorized = "Unauthorized"
        static let internalError = "Internal Server Error"
    }
}
