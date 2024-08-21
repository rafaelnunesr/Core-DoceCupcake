import Vapor

struct APINutritionalInformation: Content {
    let name: String
    let quantityDescription: String
    let dailyRepresentation: String
}
