import Vapor

struct APICardModel: Codable, Content {
    var cardHolderName: String
    var cardNumber: String
    var expiryMonth: Int
    var expiryYear: Int
    var cvv: String
    
    enum CodingKeys: String, CodingKey {
        case cardHolderName = "card_holder_name"
        case cardNumber = "card_number"
        case expiryMonth = "expiry_month"
        case expiryYear = "expiry_year"
        case cvv
    }
}
