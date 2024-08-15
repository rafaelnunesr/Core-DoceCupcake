import Foundation
import Vapor

struct SignInController: RouteCollection {
    private let dependencyProvider: DependencyProviderProtocol

    @MainActor
    init(dependencyProvider: DependencyProviderProtocol = DependencyProvider.shared) {
        self.dependencyProvider = dependencyProvider
    }

    func boot(routes: RoutesBuilder) throws {
        let signInRoutes = routes.grouped("signIn")
        signInRoutes.post(use: signIn)
    }

    @Sendable
    func signIn(req: Request) async throws -> Response {
        guard let bodyData = req.body.data else { return Response(status: .badRequest) }
        let model = try JSONDecoder().decode(SignInModel.self, from: bodyData)

        if areSignInInfoValid(model) {
            do {
                let data = try getSectionModel()
                return Response(status: .accepted, body: .init(data: data))
            } catch {
                return Response(status: .internalServerError)
            }
        }

        return Response(status: .badRequest)
    }

    private func areSignInInfoValid(_ model: SignInModel) -> Bool {
        !model.userName.isEmpty && !model.password.isEmpty
    }

    private func getSectionToken() -> String {
        let sectionTokenGenerator = dependencyProvider.getSectionTokenGeneratorInstance()
        return sectionTokenGenerator.getToken()
    }

    private func getSectionModel() throws -> Data {
        return try JSONEncoder().encode(ResponseSectionModel(userId: "1", sectionToken: getSectionToken()))
    }
}
