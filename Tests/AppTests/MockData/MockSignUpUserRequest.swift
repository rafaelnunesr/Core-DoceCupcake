@testable import App

import Foundation

struct MockSignUpUserRequest {
    static func create(userName: String = "John Smith",
                       email: String = "john@smith.com",
                       password: String = "12345678A",
                       imageUrl: String? = nil,
                       streetName: String = "Street Name",
                       addressNumber: String = "123",
                       zipCode: String = "12345678",
                       addressComplement: String? = nil,
                       state: String = "State",
                       city: String = "City",
                       country: String = "Country") -> SignUpUserRequest {
        
        SignUpUserRequest(userName: userName,
                          email: email,
                          password: password,
                          imageUrl: imageUrl,
                          streetName: streetName,
                          addressNumber: addressNumber,
                          zipCode: zipCode,
                          addressComplement: addressComplement,
                          state: state,
                          city: city, country: country)
    }
    
    var user = create()
}
