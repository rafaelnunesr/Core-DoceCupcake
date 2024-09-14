import Vapor

enum APIError {
    static var internalServerError: Abort {
        Abort(.internalServerError, reason: APIErrorMessage.Common.internalError)
    }
    
    static var notFound: Abort {
        Abort(.notFound, reason: APIErrorMessage.Common.notFound)
    }
    
    static var conflict: Abort {
        Abort(.conflict, reason: APIErrorMessage.Common.conflict)
    }
    
    static var badRequest: Abort {
        Abort(.badRequest, reason: APIErrorMessage.Common.badRequest)
    }
    static var paymentError: Abort {
        Abort(.notAcceptable, reason: APIErrorMessage.Common.badRequest) // change this
    }
    
}
