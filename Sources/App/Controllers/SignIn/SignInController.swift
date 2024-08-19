import FluentPostgresDriver
import Foundation
import Vapor

struct SignInController: RouteCollection {
    private let dependencyProvider: DependencyProviderProtocol
    private let database: Database

    init(dependencyProvider: DependencyProviderProtocol, database: Database) {
        self.dependencyProvider = dependencyProvider
        self.database = database
    }

    func boot(routes: RoutesBuilder) throws {
        let signInRoutes = routes.grouped("signIn")
        signInRoutes.post(use: signIn)
    }

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
        let result = try await UserInfo.query(on: database)
                .filter(\.$email == model.email)
                .first()

        if result?.password == model.password {
            return result?.id
        }

        return nil
    }

    private func createSectionForUser(email: String, userId: UUID) async throws -> Data {
        let sectionToken = getSectionToken()
        let sectionModel = InternalSectionModel(userId: userId, token: sectionToken)

        do {
            if let previousSection = try await getPreviousSection(userId: userId) {
                let _ = try await previousSection.delete(on: database)
            }

            let _ = try await sectionModel.create(on: database)
        } catch {
            //app.logger.report(error: error)
            throw error
        }

        return try JSONEncoder().encode(ResponseSectionModel(userId: String(userId), 
                                                             sectionToken: sectionToken))
    }

    private func getSectionToken() -> String {
        let sectionTokenGenerator = dependencyProvider.getSectionTokenGeneratorInstance()
        return sectionTokenGenerator.getToken()
    }

    private func getPreviousSection(userId: UUID) async throws -> InternalSectionModel? {
        return try await InternalSectionModel.query(on: database)
            .filter(\.$userId == userId)
            .first()
    }
}
