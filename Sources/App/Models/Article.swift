import Vapor
import FluentMySQL

final class Article: MySQLUUIDModel {
    var id: UUID?
    var title: String
    var overview: String
    var url: String

    init(id: UUID? = nil, title: String, overview: String, url: String) {
        self.id = id
        self.title = title
        self.overview = overview
        self.url = url
    }
}

extension Article: Migration { }

extension Article: Content { }

extension Article: Parameter { }
