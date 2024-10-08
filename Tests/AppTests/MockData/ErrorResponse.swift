import Vapor

@testable import App

struct ErrorResponse: Codable, Equatable {
    let error: Bool
    let reason: String
    
    init(error: Bool, reason: HTTPResponseStatus) {
        self.error = error
        self.reason = reason.reasonPhrase
    }
}
