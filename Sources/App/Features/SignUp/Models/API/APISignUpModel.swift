struct APISignUpModel: Codable {
    let userName: String
    let email: String
    let password: String
    let state: String
    let city: String
    let address: String
    let addressComplement: String?

    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case email
        case password
        case state
        case city
        case address
        case addressComplement = "adress_complement"
    }
}
