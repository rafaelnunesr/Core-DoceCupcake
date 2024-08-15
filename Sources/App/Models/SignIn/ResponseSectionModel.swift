import Foundation

struct ResponseSectionModel: Codable {
    let userId: String
    let sectionToken: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case sectionToken = "section_token"
    }
}
