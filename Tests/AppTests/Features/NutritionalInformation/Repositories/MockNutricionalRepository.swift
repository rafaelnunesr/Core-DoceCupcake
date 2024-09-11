import Foundation

@testable import App

final class MockNutricionalRepository: NutritionalRepositoryProtocol {
    var result: (any DatabaseModelProtocol)?
    
    func getNutritionalByAllFields(_ model: NutritionalInformation) async throws -> NutritionalInformation? {
        if let result = result as? NutritionalInformation {
            return result
        }
        
        return nil
    }

    func fetchAllResults<T: DatabaseModelProtocol>() async throws -> [T] {
        if let result = result as? T {
            return [result]
        }
        
        return []
    }

    func fetchModelById<T: DatabaseModelProtocol>(_ id: UUID) async throws -> T? {
        if let result = result as? T {
            return result
        }
        
        return nil
    }

    func fetchModelByCode<T: DatabaseModelProtocol>(_ code: String) async throws -> T? {
        if let result = result as? T {
            return result
        }
        
        return nil
    }

    func create<T: DatabaseModelProtocol>(_ model: T) async throws {
        result = model
    }
    
    func update<T>(_ model: T) async throws where T : App.DatabaseModelProtocol {
        result = model
    }

    func delete<T: DatabaseModelProtocol>(_ model: T) async throws {
        result = nil
    }
}
