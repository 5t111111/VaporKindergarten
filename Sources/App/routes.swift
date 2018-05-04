import Routing
import Vapor
import FluentMySQL
import Crypto

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    let articleController = ArticleController()
    router.get(use: articleController.index)
    router.get("articles", use: articleController.index)
    router.post("articles", use: articleController.create)
    router.get("articles", "new", use: articleController.new)
//    router.get("users", Int.parameter, use: articleController.show)
//    router.get("users", "edit", Int.parameter, use: articleController.edit)
//    router.post("users", Int.parameter, use: articleController.update)

    let sessionController = SessionController()
    router.get("sessions", "new", use: sessionController.new)
    router.post("sessions", use: sessionController.create)
}

func isLoggedIn(_ req: Request) -> Bool {
    guard let _ = getUserEmail(req) else {
        return false
    }
    return true
}

func getUserEmail(_ req: Request) -> String? {
    let session = try? req.session()
    return session?["email"]
}
