import Vapor

protocol DependencyProviderProtocol {
    func getSectionTokenGeneratorInstance() -> SectionTokenGeneratorProtocol
}
