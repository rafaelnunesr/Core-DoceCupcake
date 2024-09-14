import Vapor

func convertRequestDataToModel<T: Decodable>(req: Request) throws -> T {
    guard let bodyData = req.body.data else {
        throw APIResponseError.Common.badRequest
    }

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    return try decoder.decode(T.self, from: bodyData)
}
