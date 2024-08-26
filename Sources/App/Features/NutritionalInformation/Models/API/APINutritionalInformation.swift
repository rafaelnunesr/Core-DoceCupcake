import Vapor

struct APINutritionalInformation: Content, Codable {
    let code: String
    let name: String
    let quantityDescription: String
    let dailyRepresentation: String

    enum CodingKeys: String, CodingKey {
        case code
        case name
        case quantityDescription = "quantity_description"
        case dailyRepresentation = "daily_representation"
    }
}

extension APINutritionalInformation {
    init(from model: InternalNutritionalModel) {
        code = model.code
        name = model.name
        quantityDescription = model.quantityDescription
        dailyRepresentation = model.dailyRepresentation
    }
}
