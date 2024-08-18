import FluentPostgresDriver
import Vapor

struct SignUpController: RouteCollection {
    private let database: Database

    init(database: Database) {
        self.database = database
    }

    func boot(routes: RoutesBuilder) throws {
        let signUpRoutes = routes.grouped("signUp")
        signUpRoutes.post(use: signUp)
    }

    @Sendable
    func signUp(req: Request) async throws -> Response {
        guard let bodyData = req.body.data else { return Response(status: .badRequest) }
        let model = try JSONDecoder().decode(SignUpModel.self, from: bodyData)

        if try await isUserAlreadyRegistered(with: model.email) {
            return Response(status: .conflict)
        }
        
        if !areCredentialsValid(model) {
            return Response(status: .badRequest)
        }

        createUser(with: model)

        return Response(status: .accepted)

    }

    private func isUserAlreadyRegistered(with email: String) async throws -> Bool {
        return try await Person.query(on: database)
            .filter(\.$email == email)
            .first() != nil
    }

    private func areCredentialsValid(_ model: SignUpModel) -> Bool {
        model.email.isValidEmail && model.password.isValidPassword
    }

    private func createUser(with model: SignUpModel) {
        let userModel = Person(userName: model.userName,
                               email: model.email,
                               password: model.password,
                               state: model.state,
                               city: model.city,
                               address: model.address,
                               addressComplement: model.addressComplement)

        let _ = userModel.create(on: database)
    }
}
