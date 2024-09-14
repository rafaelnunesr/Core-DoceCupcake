protocol CountryProtocol: CaseIterable, Codable {
    var fullName: String { get }
}

enum Country: String, Codable {
    case brazil = "Brazil"
    
    var states: [String] {
        switch self {
        case .brazil:
            return BrazilState.allCases.map { $0.rawValue.uppercased() }
        }
    }
}
