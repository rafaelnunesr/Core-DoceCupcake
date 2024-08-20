import FluentKit
import Vapor

protocol ApplicationProtocol {
    var db: Database { get }
    var databases: Databases { get }
    var migrations: Migrations { get }
    var logger: Logger { get set }
    func asyncShutdown() async throws
    func register(collection: RouteCollection) throws
}


extension Application: ApplicationProtocol {}
