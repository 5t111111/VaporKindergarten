import Foundation
import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    let articleController = ArticleController()
    router.get(use: articleController.index)
    router.group("articles") { group in
        group.get(use: articleController.index)
        group.get("new", use: articleController.new)
        group.post(use: articleController.create)
        group.get("edit", UUID.parameter, use: articleController.edit)
        group.post("update", UUID.parameter, use: articleController.update)
    }

    let sessionController = SessionController()
    router.group("sessions") { group in
        group.get("new", use: sessionController.new)
        group.post(use: sessionController.create)
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
    return session?["user_id"]
}
