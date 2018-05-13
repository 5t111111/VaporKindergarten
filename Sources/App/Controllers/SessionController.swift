import Vapor
import Fluent
import Authentication

final class SessionController {
    struct LoginRequest: Content {
        var email: String
        var password: String
    }

    func new(_ req: Request) throws -> Future<View> {
        return try req.view().render("sessions/new")
    }

    func create(_ req: Request) throws -> Future<AnyResponse> {
        let loginRequest = try req.content.syncDecode(LoginRequest.self)
        let auth = BasicAuthorization(username: loginRequest.email, password: loginRequest.password)

        return User.authenticate(using: auth, verifier: BCryptDigest(), on: req).map(to: AnyResponse.self) { user in
            if let user = user {
                let session = try req.session()
                session["user_id"] = String(user.id!)
                let redirect = req.redirect(to: "/articles")
                return AnyResponse(redirect)
            } else {
                let context = ["error": "Invalid username or password"]
                let page = try req.view().render("sessions/new", context)
                return AnyResponse(page)
            }
        }
    }
}
