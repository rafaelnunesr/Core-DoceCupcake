protocol DependencyProviderProtocol {
    func getDatabaseInstance() -> DatabaseProtocol?
    func getSectionTokenGeneratorInstance() -> SectionTokenGeneratorProtocol
}
