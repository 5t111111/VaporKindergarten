import Routing
import Vapor

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
}
