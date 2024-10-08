import Foundation
import Vapor

@testable import App

func convertBodyToGenericMessageResponse(with body: ByteBuffer) -> GenericMessageResponse {
    let data = Data(buffer: body)
    let content = try? JSONDecoder().decode(GenericMessageResponse.self, from: data)
    return content ?? GenericMessageResponse(message: .empty)
}

func convertRequestDataToModel<T: Decodable>(with body: ByteBuffer) throws -> T? {
    let data = Data(buffer: body)
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    let content = try decoder.decode(T.self, from: data)
    return content
}
