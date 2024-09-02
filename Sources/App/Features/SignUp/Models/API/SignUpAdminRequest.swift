struct SignUpAdminRequest: Codable {
    let userName: String
    let email: String
    var password: String

    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case email
        case password
    }
}
