@testable import App

struct ErrorResponse: Codable, Equatable {
    let error: Bool
    let reason: String
}
