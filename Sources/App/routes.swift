import Routing
import Vapor
import FluentMySQL
import Crypto

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    let articleController = ArticleController()
    router.get("articles", use: articleController.index)
    router.post("articles", use: articleController.create)
//    router.get("articles", "new", use: articleController.new)
//    router.get("users", Int.parameter, use: articleController.show)
//    router.get("users", "edit", Int.parameter, use: articleController.edit)
//    router.post("users", Int.parameter, use: articleController.update)

    router.get("users", "login") { req -> Future<View> in
        return try req.view().render("users-login")
    }

    router.post(User.self, at: "users", "login") { req, user -> Future<Response> in
        return try User.query(on: req)
            .filter(\User.email == user.email)
            .first().map(to: Response.self) { existing in
                guard let existing = existing else {
                    throw Abort(.forbidden, reason: "Invalid email or password.")
                }
                guard try BCrypt.verify(user.password, created: existing.password) else {
                    throw Abort(.forbidden, reason: "Invalid email or password.")
                }
                let session = try req.session()
                session["email"] = existing.email
                return req.redirect(to: "/articles")
            }
    }
}

func getUserEmail(_ req: Request) -> String? {
    let session = try? req.session()
    return session?["email"]
}
