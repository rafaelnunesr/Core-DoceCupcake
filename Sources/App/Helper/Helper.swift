import Vapor

func convertRequestDataToModel<T: Decodable>(req: Request) throws -> T {
    guard let bodyData = req.body.data else {
        throw Abort(.badRequest, reason: APIErrorMessage.Common.badRequest)
    }

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    return try decoder.decode(T.self, from: bodyData)
}
