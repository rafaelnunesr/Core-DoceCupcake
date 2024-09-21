@testable import App

struct ErrorResponseHelper {
    static var conflictError: ErrorResponse {
        ErrorResponse(error: true, reason: "Conflict")
    }

    static var notFound: ErrorResponse {
        ErrorResponse(error: true, reason: "Not Found")
    }
    
    static var invalidEmailOrPassword: ErrorResponse {
        ErrorResponse(error: true, reason: "Invalid email/password")
    }
    
    static var userAlreadyRegistered: ErrorResponse {
        ErrorResponse(error: true, reason: "User already registered")
    }
}
