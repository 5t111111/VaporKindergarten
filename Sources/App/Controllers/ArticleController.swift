import Vapor
import Crypto

final class ArticleController {
    func index(_ req: Request) throws -> Future<View> {
        let allArticles = Article.query(on: req).all()
        return allArticles.flatMap(to: View.self) { articles in
            let data = ["articles": articles]
            return try req.view().render("articles/index", data)
        }
    }

    enum ViewOrRedirect: ResponseEncodable {
        func encode(for req: Request) throws -> Future<Response> {
            switch self {
            case .redirect(let path): return Future.map(on: req) { req.redirect(to: path) }
            case .view(let view): return try view.encode(for: req)
            }
        }

        case redirect(String)
        case view(View)
    }

    func new(_ req: Request) throws -> Future<ViewOrRedirect> {
        guard isLoggedIn(req) else {
            return Future.map(on: req) { .redirect("/sessions/new") }
        }
        return try req.view().render("articles/new").map(to: ViewOrRedirect.self) { view in
            return .view(view)
        }
    }

    func create(_ req: Request) throws -> Future<Article> {
        return try req.content.decode(Article.self).flatMap(to: Article.self) { article in
            return article.save(on: req)
        }
    }

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Article.self).flatMap(to: Void.self) { article in
            return article.delete(on: req)
        }.transform(to: .ok)
    }
}
