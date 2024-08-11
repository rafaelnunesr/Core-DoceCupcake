import Vapor

struct SectionModel {
    let userId: String
    let token: String
}

extension SectionModel: AsyncResponseEncodable {
    func encodeResponse(for request: Request) async throws -> Response {
        return Response()
    }
}
