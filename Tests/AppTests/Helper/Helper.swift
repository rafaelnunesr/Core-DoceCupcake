import Foundation
import Vapor

@testable import App

func convertBodyToErrorResponse(with body: ByteBuffer) -> ErrorResponse {
    let data = Data(buffer: body)
    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
    return errorResponse ?? ErrorResponse(error: false, reason: .empty)
}

func convertBodyToGenericMessageResponse(with body: ByteBuffer) -> GenericMessageResponse {
    let data = Data(buffer: body)
    let content = try? JSONDecoder().decode(GenericMessageResponse.self, from: data)
    return content ?? GenericMessageResponse(message: .empty)
}
