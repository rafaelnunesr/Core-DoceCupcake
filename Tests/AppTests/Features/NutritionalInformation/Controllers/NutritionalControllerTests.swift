import XCTVapor

@testable import App

final class NutritionalControllerTests: XCTestCase {
    private var app: Application!
    private var sut: NutritionalController!
    private var mockRepository: MockNutricionalRepository!
    private var mockSecurity: MockSecurity!
    private var mockDependencyProvider: MockDependencyProvider!
    
    override func setUp() async throws {
        app = try await Application.make(.testing)
        mockRepository = MockNutricionalRepository()
        mockSecurity = MockSecurity()
        mockDependencyProvider = MockDependencyProvider(app: app, security: mockSecurity)
        sut = NutritionalController(repository: mockRepository)
    }
    
    override func tearDown() async throws {
        try await self.app.asyncShutdown()
        app = nil
        sut = nil
        mockRepository = nil
        mockSecurity = nil
        mockDependencyProvider = nil
    }
    
    func test_get_nutritional_by_ids_should_return_correct_values() async throws {
        let nutritionalInformation = MockNutritionalInformation().infoA
        mockRepository.result = nutritionalInformation
        
        let result = try await sut.getNutritionalByIds([UUID()])
        XCTAssertEqual(result.first?.code, nutritionalInformation.code)
        XCTAssertEqual(result.first?.name, nutritionalInformation.name)
        XCTAssertEqual(result.first?.quantityDescription, nutritionalInformation.quantityDescription)
        XCTAssertEqual(result.first?.dailyRepresentation, nutritionalInformation.dailyRepresentation)
    }
    
    func test_save_new_nutritional_information_should_return_correct_values() async throws {
        let nutritionalInformation = MockNutritionalInformation().infoA
        
        let result = try await sut.saveNutritionalModel(nutritionalInformation)
        XCTAssertEqual(result.code, nutritionalInformation.code)
        XCTAssertEqual(result.name, nutritionalInformation.name)
        XCTAssertEqual(result.quantityDescription, nutritionalInformation.quantityDescription)
        XCTAssertEqual(result.dailyRepresentation, nutritionalInformation.dailyRepresentation)
    }
    
    func test_save_repeated_nutritional_information_should_return_correct_values() async throws {
        let nutritionalInformation = MockNutritionalInformation().infoA
        mockRepository.result = nutritionalInformation
        
        let result = try await sut.saveNutritionalModel(nutritionalInformation)
        XCTAssertEqual(result.code, nutritionalInformation.code)
        XCTAssertEqual(result.name, nutritionalInformation.name)
        XCTAssertEqual(result.quantityDescription, nutritionalInformation.quantityDescription)
        XCTAssertEqual(result.dailyRepresentation, nutritionalInformation.dailyRepresentation)
    }
}
