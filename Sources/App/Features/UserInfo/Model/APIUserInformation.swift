import Vapor

final class APIUserInformation: Content, Codable, Equatable {
    let userName: String
    let email: String
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

    init(userName: String,
         email: String,
         imageUrl: String? = nil,
         phoneNumber: String,
         streetName: String,
         addressNumber: String, zipCode: String,
         addressComplement: String,
         state: String,
         city: String,
         country: String) {
        self.userName = userName
        self.email = email
        self.imageUrl = imageUrl
        self.phoneNumber = phoneNumber
        self.streetName = streetName
        self.addressNumber = addressNumber
        self.zipCode = zipCode
        self.addressComplement = addressComplement
        self.state = state
        self.city = city
        self.country = country
    }
    
    static func == (lhs: APIUserInformation, rhs: APIUserInformation) -> Bool {
        lhs.userName == rhs.userName &&
        lhs.email == rhs.email &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.phoneNumber == rhs.phoneNumber &&
        lhs.streetName == rhs.streetName &&
        lhs.addressNumber == rhs.addressNumber &&
        lhs.zipCode == rhs.zipCode &&
        lhs.addressComplement == rhs.addressComplement &&
        lhs.state == rhs.state &&
        lhs.city == rhs.city &&
        lhs.country == rhs.country
    }
    
}

extension APIUserInformation {
    convenience init(from user: User, address: Address) {
        self.init(userName: user.userName,
                  email: user.email,
                  phoneNumber: user.phoneNumber,
                  streetName: address.streetName,
                  addressNumber: address.number,
                  zipCode: address.zipCode,
                  addressComplement: address.complementary,
                  state: address.state,
                  city: address.city, country: address.country)
    }
}
