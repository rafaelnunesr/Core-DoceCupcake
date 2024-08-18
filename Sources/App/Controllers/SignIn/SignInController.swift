import FluentPostgresDriver
import Foundation
import Vapor

struct SignInController: RouteCollection {
    private let dependencyProvider: DependencyProviderProtocol
    private let database: Database

    @MainActor
    init(dependencyProvider: DependencyProviderProtocol = DependencyProvider.shared,
         database: Database) {
        self.dependencyProvider = dependencyProvider
        self.database = database
    }

    func boot(routes: RoutesBuilder) throws {
        let signInRoutes = routes.grouped("signIn")
        signInRoutes.post(use: signIn)
    }

    @Sendable
    func signIn(req: Request) async throws -> Response {
        guard let bodyData = req.body.data else { return Response(status: .badRequest) }
        let model = try JSONDecoder().decode(SignInModel.self, from: bodyData)

        guard let userId = try await getUserId(model) else {
            return Response(status: .badRequest)
        }

        let data = try await createSectionForUser(email: model.email, userId: userId)
        return Response(status: .accepted, body: .init(data: data))
    }

    private func getUserId(_ model: SignInModel) async throws -> UUID? {
        let result = try await Person.query(on: database)
                .filter(\.$email == model.email)
                .first()

        if result?.password == model.password {
            return result?.id
        }

        return nil
    }

    private func createSectionForUser(email: String, userId: UUID) async throws -> Data {
        let sectionToken = getSectionToken()
        let sectionModel = InternalSectionModel(userId: userId,
                                                token: sectionToken)



        let _ = try await sectionModel.save(on: database)

        return try JSONEncoder().encode(ResponseSectionModel(userId: String(userId), 
                                                             sectionToken: sectionToken))
    }

    private func getSectionToken() -> String {
        let sectionTokenGenerator = dependencyProvider.getSectionTokenGeneratorInstance()
        return sectionTokenGenerator.getToken()
    }
}
