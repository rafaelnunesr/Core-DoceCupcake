struct SignUpUserRequest: Codable {
    let userName: String
    let email: String
    var password: String
    var imageUrl: String?
    let state: String
    let city: String
    let address: String
    let addressComplement: String?

    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case email
        case password
        case imageUrl = "image_url"
        case state
        case city
        case address
        case addressComplement = "adress_complement"
    }
}
