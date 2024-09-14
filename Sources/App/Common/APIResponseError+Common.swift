import Vapor

extension APIResponseError {
    enum Common {
        static var internalServerError: Abort {
            Abort(.internalServerError)
        }
        
        static var notFound: Abort {
            Abort(.notFound)
        }
        
        static var conflict: Abort {
            Abort(.conflict)
        }
        
        static var badRequest: Abort {
            Abort(.badRequest)
        }
        
        static var unauthorized: Abort {
            Abort(.unauthorized)
        }
    }
}
extension APIResponseError {
    enum Product {
        static var invalidProductTag: Abort {
            Abort(.badRequest)
        }
    }
}
