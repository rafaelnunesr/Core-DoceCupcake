import Foundation

@testable import App

struct MockNutritionalInformation {
    static func create(id: UUID? = UUID(),
                       code: String = "A",
                       name: String = "info_a",
                       quantityDescription: String = "1",
                       dailyRepresentation: String = "A") -> NutritionalInformation {
        NutritionalInformation(id: id,
                             code: code,
                             name: name,
                             quantityDescription: quantityDescription,
                             dailyRepresentation: dailyRepresentation)
    }
    
    var infoA = create()
}

struct MockAPINutritionalInformation {
    static func create(code: String = "A",
                       name: String = "info_a",
                       quantityDescription: String = "1",
                       dailyRepresentation: String = "A") -> APINutritionalInformation {
        APINutritionalInformation(code: code,
                                  name: name,
                                  quantityDescription: quantityDescription,
                                  dailyRepresentation: dailyRepresentation)
    }
    
    var infoA = create()
}
