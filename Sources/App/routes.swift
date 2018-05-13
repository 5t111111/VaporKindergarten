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
    router.group("articles") { group in
        group.get(use: articleController.index)
        group.post(use: articleController.create)
        group.get("new", use: articleController.new)
    }

    let sessionController = SessionController()
    router.group("sessions") { group in
        group.get("sessions", "new", use: sessionController.new)
        group.post("sessions", use: sessionController.create)
    }
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
