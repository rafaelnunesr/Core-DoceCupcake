import Fluent
import Vapor

enum AddressDbField: String {
    case schema = "address"
    
    case id
    case createdAt = "created_at"
    case userId = "user_id"
    case streetName = "street_name"
    case number
    case zipCode = "zip_code"
    case complementary
    case state
    case city
    case country
    
    var fieldKey: FieldKey {
        return FieldKey(stringLiteral: self.rawValue)
    }
}

final class Address: Model {
    static let schema = AddressDbField.schema.rawValue

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: AddressDbField.createdAt.fieldKey, on: .create)
    var createdAt: Date?

    @Parent(key: AddressDbField.userId.fieldKey)
    var user: User
    
    @Field(key: AddressDbField.streetName.fieldKey)
    var streetName: String
    
    @Field(key: AddressDbField.number.fieldKey)
    var number: String
    
    @Field(key: AddressDbField.zipCode.fieldKey)
    var zipCode: String
    
    @OptionalField(key: AddressDbField.complementary.fieldKey)
    var complementary: String?
    
    @Field(key: AddressDbField.state.fieldKey)
    var state: String
    
    @Field(key: AddressDbField.city.fieldKey)
    var city: String
    
    @Field(key: AddressDbField.country.fieldKey)
    var country: String
    
    internal init() {}

    init(id: UUID? = nil, 
         createdAt: Date? = nil,
         user: User,
         streetName: String,
         number: String,
         zipCode: String,
         complementary: String? = nil,
         state: String,
         city: String,
         country: String) {
        self.id = id
        self.createdAt = createdAt
        self.user = user
        self.streetName = streetName
        self.number = number
        self.zipCode = zipCode
        self.complementary = complementary
        self.state = state
        self.city = city
        self.country = country
    }
}