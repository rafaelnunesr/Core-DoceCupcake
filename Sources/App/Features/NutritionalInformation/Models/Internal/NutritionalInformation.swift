import Fluent
import Vapor

enum NutritionalInformationDbField: String {
    case schema = "nutritional_information"
    case code
    case name
    case quantityDescription = "quantity_description"
    case dailyRepresentation = "daily_representation"
    
    var fieldKey: FieldKey {
        return FieldKey(stringLiteral: self.rawValue)
    }
}

final class NutritionalInformation: DatabaseModelProtocol  {
    static let schema = NutritionalInformationDbField.schema.rawValue

    @ID(key: .id)
    var id: UUID?

    @Field(key: NutritionalInformationDbField.code.fieldKey)
    var code: String

    @Field(key: NutritionalInformationDbField.name.fieldKey)
    var name: String

    @Field(key: NutritionalInformationDbField.quantityDescription.fieldKey)
    var quantityDescription: String

    @Field(key: NutritionalInformationDbField.dailyRepresentation.fieldKey)
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

