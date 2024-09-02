import Fluent
import Vapor

final class NutritionalInformation: DatabaseModelProtocol {
    static let schema = "nutritional_information"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "code")
    var code: String

    @Field(key: "name")
    var name: String

    @Field(key: "quantity_description")
    var quantityDescription: String

    @Field(key: "daily_representation")
    var dailyRepresentation: String

    internal init() { }

    init(id: UUID? = nil,
         code: String,
         name: String,
         quantityDescription: String,
         dailyRepresentation: String) {
        self.id = id
        self.code = code
        self.name = name
        self.quantityDescription = quantityDescription
        self.dailyRepresentation = dailyRepresentation
    }
}

extension NutritionalInformation {
    static var codeKey: KeyPath<NutritionalInformation, Field<String>> {
        \NutritionalInformation.$code
    }

    static var idKey: KeyPath<NutritionalInformation, IDProperty<NutritionalInformation, UUID>> {
        \NutritionalInformation.$id
    }
}

extension NutritionalInformation {
    convenience init(from model: APINutritionalInformation) {
        self.init(code: model.code,
                  name: model.name,
                  quantityDescription: model.quantityDescription,
                  dailyRepresentation: model.dailyRepresentation)
    }
}

