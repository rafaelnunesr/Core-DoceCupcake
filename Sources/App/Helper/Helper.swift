import Vapor

func convertRequestDataToModel<T: Decodable>(req: Request) throws -> T {
    guard let bodyData = req.body.data else {
        throw Abort(.badRequest, reason: APIErrorMessage.Common.badRequest)
    }

    return try JSONDecoder().decode(T.self, from: bodyData)
}
