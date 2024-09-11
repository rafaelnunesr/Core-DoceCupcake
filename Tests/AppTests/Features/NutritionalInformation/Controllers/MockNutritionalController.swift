import Foundation

@testable import App

final class MockNutritionalController: NutritionalControllerProtocol {
    var information: NutritionalInformation?
    
    func getNutritionalByIds(_ idList: [UUID]) async throws -> [NutritionalInformation] {
        if let information {
            return [information]
        }
        
        return []
    }

    func saveNutritionalModel(_ model: NutritionalInformation) async throws -> NutritionalInformation {
        model
    }

    func deleteNutritionalModel(_ model: NutritionalInformation) async throws {
        information = nil
    }
}
