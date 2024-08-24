import Fluent
import Vapor

final class InternalNutritionalModel: Model {
    static let schema = "nutritional"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "quantity_description")
    var quantityDescription: String

    @Field(key: "daily_representation")
    var dailyRepresentation: String

    internal init() { }

    init(id: UUID? = nil,
         name: String,
         quantityDescription: String,
         dailyRepresentation: String) {
        self.id = id
        self.name = name
        self.quantityDescription = quantityDescription
        self.dailyRepresentation = dailyRepresentation
    }
}

extension InternalNutritionalModel {
    convenience init(from model: APINutritionalInformation) {
        self.init(name: model.name,
                  quantityDescription: model.quantityDescription,
                  dailyRepresentation: model.dailyRepresentation)
    }
}

