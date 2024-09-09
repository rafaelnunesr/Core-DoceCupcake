import XCTVapor

@testable import App

final class ProductTagsControllerTests: XCTestCase {
    private var app: Application!
    private var sut: ProductTagsController!
    private var mockRepository: MockRepository!
    private var mockSecurity: MockSecurity!
    private var mockDependencyProvider: MockDependencyProvider!
    
    override func setUp() async throws {
        app = try await Application.make(.testing)
        mockRepository = MockRepository()
        mockSecurity = MockSecurity()
        mockDependencyProvider = MockDependencyProvider(app: app, security: mockSecurity)
        sut = ProductTagsController(dependencyProvider: mockDependencyProvider, repository: mockRepository)
    }
    
    override func tearDown() async throws {
        try await self.app.asyncShutdown()
        app = nil
        sut = nil
        mockRepository = nil
        mockSecurity = nil
        mockDependencyProvider = nil
    }
    
    func test_get_product_tags_list_should_return_correct_list() throws {
        mockRepository.result = MockProductTags().tagA
    }
}
