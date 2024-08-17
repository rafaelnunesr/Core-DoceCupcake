import Vapor

protocol DependencyProviderProtocol {
    func getDatabaseInstance() -> DatabaseProtocol?
    func getSectionTokenGeneratorInstance() -> SectionTokenGeneratorProtocol
    func setupDatabase(app: Application)
}
