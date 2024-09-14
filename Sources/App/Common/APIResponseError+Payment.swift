import Vapor

extension APIResponseError {
    enum Payment {
        static var paymentError: Abort {
            Abort(.notAcceptable)
        }
    }
}
