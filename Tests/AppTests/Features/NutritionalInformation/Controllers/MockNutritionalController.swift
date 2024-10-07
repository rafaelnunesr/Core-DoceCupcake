import Foundation

@testable import App

final class MockNutritionalController: NutritionalControllerProtocol {
    var information: NutritionalInformation?
    
    func fetchNutritionalByIds(_ idList: [UUID]) async throws -> [NutritionalInformation] {
        if let information {
            return [information]
        }
        
        return []
    }

    func save(_ model: NutritionalInformation) async throws -> NutritionalInformation {
        model
    }

    func delete(_ model: NutritionalInformation) async throws {
        information = nil
    }
}
