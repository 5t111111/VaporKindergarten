import Foundation
import Vapor

final class ArticleController {
    func index(_ req: Request) throws -> Future<View> {
        let allArticles = Article.query(on: req).all()
        return allArticles.flatMap(to: View.self) { articles in
            let context = ["articles": articles]
            return try req.view().render("articles/index", context)
        }
    }

    func new(_ req: Request) throws -> Future<AnyResponse> {
        guard isLoggedIn(req) else {
            let redirect = req.redirect(to: "/sessions/new")
            return Future.map(on: req) { AnyResponse(redirect) }
        }
        let page = try req.view().render("articles/new")
        return Future.map(on: req) { AnyResponse(page) }
    }

    func create(_ req: Request) throws -> Future<Article> {
        guard isLoggedIn(req) else {
            throw Abort(.unauthorized)
        }
        return try req.content.decode(Article.self).flatMap(to: Article.self) { article in
            return article.save(on: req)
        }
    }

    func edit(_ req: Request) throws -> Future<AnyResponse> {
        guard isLoggedIn(req) else {
            let redirect = req.redirect(to: "/sessions/new")
            return Future.map(on: req) { AnyResponse(redirect) }
        }

        let id = try req.parameters.next(UUID.self)

        return try Article.find(id, on: req).map(to: AnyResponse.self) { existing in
            guard let existing = existing else {
                throw Abort(.notFound)
            }

            let context = ["article": existing]
            let page = try req.view().render("articles/edit", context)
            return AnyResponse(page)
        }
    }

    func update(_ req: Request) throws -> Future<Article> {
        guard isLoggedIn(req) else {
            throw Abort(.unauthorized)
        }

        let id = try req.parameters.next(UUID.self)
        let article = try req.content.syncDecode(Article.self)

        return try Article.find(id, on: req).flatMap(to: Article.self) { existing in
            guard var existing = existing else {
                throw Abort(.notFound)
            }

            existing.title = article.title
            existing.overview = article.overview
            existing.url = article.url
            existing.category = article.category
            existing.targetVersion = article.targetVersion
            return existing.save(on: req)
        }
    }

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        guard isLoggedIn(req) else {
            throw Abort(.unauthorized)
        }
        return try req.parameters.next(Article.self).flatMap(to: Void.self) { article in
            return article.delete(on: req)
        }.transform(to: .ok)
    }
}
