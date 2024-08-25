struct APISignUpManagerModel: Codable {
    let userName: String
    let email: String
    let password: String

    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case email
        case password
    }
}
