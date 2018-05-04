import Vapor
import Fluent
import Crypto

struct LoginRequest: Content {
    var email: String
    var password: String
}

final class SessionController {
    func new(_ req: Request) throws -> Future<View> {
        return try req.view().render("sessions/new")
    }

    func create(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(LoginRequest.self).flatMap { loginRequest in
            return User.query(on: req)
                .filter(try \User.email == loginRequest.email)
                .first()
                .map(to: Response.self) { existingUser in
                    guard let existingUser = existingUser else {
                        throw Abort(.forbidden, reason: "Invalid email or password.")
                    }
                    guard try BCrypt.verify(loginRequest.password, created: existingUser.password) else {
                        throw Abort(.forbidden, reason: "Invalid email or password.")
                    }
                    let session = try req.session()
                    session["email"] = existingUser.email
                    return req.redirect(to: "/articles")
                }

        }
    }
}
