import Vapor

final class APIUserInformationRequest: Content, Codable, Equatable {
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
    let currentPassword: String
    let newPassword: String?

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
        case currentPassword = "current_password"
        case newPassword = "new_password"
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
         country: String,
         currentPassword: String,
         newPassword: String? = nil) {
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
        self.currentPassword = currentPassword
        self.newPassword = newPassword
    }
    
    static func == (lhs: APIUserInformationRequest, rhs: APIUserInformationRequest) -> Bool {
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
        lhs.country == rhs.country &&
        lhs.currentPassword == rhs.currentPassword &&
        lhs.newPassword == rhs.newPassword
    }
    
}
