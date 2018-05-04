import Vapor
import FluentMySQL

final class Article: MySQLModel {
    var id: Int?
    var title: String
    var overview: String
    var url: String
    var targetVersion: String

    init(id: Int? = nil, title: String, overview: String, url: String, targetVersion: String) {
        self.id = id
        self.title = title
        self.overview = overview
        self.url = url
        self.targetVersion = targetVersion
    }
}

extension Article: Migration { }

extension Article: Content { }

extension Article: Parameter { }
