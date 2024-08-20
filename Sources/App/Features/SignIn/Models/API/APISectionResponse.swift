import Vapor

struct APISectionResponse: Content {
    let userId: UUID
    let sectionToken: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case sectionToken = "section_token"
    }
}
