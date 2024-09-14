import Vapor

struct APIAddress: Content, Codable {
    var streetName: String
    var number: String
    var zipCode: String
    var complementary: String?
    var state: String
    var city: String
    var country: String
   
    enum CodingKeys: String, CodingKey {
        case streetName = "street_name"
        case number
        case zipCode = "zip_code"
        case complementary
        case state
        case city
        case country
    }
}

extension APIAddress {
    init(from model: Address) {
        streetName = model.streetName
        number = model.number
        zipCode = model.zipCode
        complementary = model.complementary
        state = model.state
        city = model.city
        country = model.country
    }
}
