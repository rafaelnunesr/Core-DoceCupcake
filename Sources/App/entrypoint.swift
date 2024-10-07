import Vapor
import Logging
import NIOCore
import NIOPosix

@main
enum Entrypoint {
    static func main() async throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)
        
        let app = try await Application.make(env)
        
        let dependencyProvider = DependencyProvider(app: app)
        let configuration = AppConfiguration(dependencyProvider: dependencyProvider)
        try await configuration.initialSetup()
        try await app.execute()
        try await app.asyncShutdown()
    }
}
