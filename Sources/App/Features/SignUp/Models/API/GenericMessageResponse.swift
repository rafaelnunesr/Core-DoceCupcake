import Vapor

struct GenericMessageResponse: Content, Equatable {
    let message: String
}
