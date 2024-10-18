import Vapor

final class ReviewMigrationService: MigrationServiceProtocol {
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }
    
    func addMigrations() {
        app.migrations.add(CreateReviewMigration())
    }
}
