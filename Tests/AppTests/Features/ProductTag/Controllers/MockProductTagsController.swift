import Vapor

@testable import App

struct MockProductTagsController: ProductTagsControllerProtocol {
    var areTagsValid = false
    var productTag: ProductTag?
    
    func boot(routes: RoutesBuilder) throws {}
    
    func areTagCodesValid(_ tagCodeList: [String]) async throws -> Bool {
        areTagsValid
    }

    func getTagsFor(_ tagCodeList: [String]) async throws -> [ProductTag] {
        if let productTag {
            return [productTag]
        }
        
        return []
    }
}
