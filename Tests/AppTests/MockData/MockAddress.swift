import Foundation

@testable import App

struct MockAddress {
    static func create(id: UUID? = UUID(),
                       createdAt: Date? = Date(),
                       userId: UUID = UUID(),
                       streetName: String = "Street name",
                       number: String = "1234",
                       zipCode: String = "78945",
                       complementary: String = "complementary",
                       state: String = "CA",
                       city: String = "Anycity",
                       country: String = "USA") -> Address {
        Address(id: id,
                createdAt: createdAt,
                userId: userId,
                streetName: streetName,
                number: number, zipCode: zipCode,
                complementary: complementary,
                state: state,
                city: city,
                country: country)
    }
    
    var addressA = create()
    var addressB = create()
}
