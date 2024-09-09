import FluentPostgresDriver
import Vapor

@testable import App

final class MockRepository: RepositoryProtocol {
    var result: (any DatabaseModelProtocol)?
    
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

    func delete<T: DatabaseModelProtocol>(_ model: T) async throws {
        result = nil
    }
}
