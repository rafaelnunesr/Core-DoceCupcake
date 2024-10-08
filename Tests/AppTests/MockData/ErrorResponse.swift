import Vapor

@testable import App

struct ErrorResponse: Codable, Equatable {
    let error: Bool
    let reason: String
    
    init(error: Bool, reason: String) {
        self.error = error
        self.reason = reason
    }
}
