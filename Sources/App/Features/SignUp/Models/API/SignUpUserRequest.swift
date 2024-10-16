import Vapor

struct SignUpUserRequest: Codable, Content {
    let userName: String
    let email: String
    var password: String
    var imageUrl: String?
    let phoneNumber: String
    let streetName: String
    let addressNumber: String
    let zipCode: String
    var addressComplement: String
    let state: String
    let city: String
    let country: String

    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case email
        case password
        case imageUrl = "image_url"
        case phoneNumber = "phone_number"
        case streetName = "street_name"
        case addressNumber = "address_number"
        case zipCode = "zip_code"
        case addressComplement = "address_complement"
        case state
        case city
        case country
    }
}
