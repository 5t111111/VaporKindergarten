import Vapor
import Crypto

final class ArticleController {
    func index(_ req: Request) throws -> Future<View> {
        guard let _ = getUserEmail(req) else {
            throw Abort(.unauthorized)
        }

        let allArticles = Article.query(on: req).all()
        return allArticles.flatMap(to: View.self) { articles in
            let data = ["articles": articles]
            return try req.view().render("articles/index", data)
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
