struct SignInModel: Codable {
    let userName: String
    let password: String

    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case password
    }
}
