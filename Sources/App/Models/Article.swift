import Foundation
import Vapor
import Fluent
import FluentPostgreSQL

struct Article: Codable {
    var id: UUID?
    var title: String
    var overview: String
    var url: String
    var category: String
    var targetVersion: String

    init(title: String, overview: String, url: String, category: String, targetVersion: String) {
        self.title = title
        self.overview = overview
        self.url = url
        self.category = category
        self.targetVersion = targetVersion
    }
}

extension Article: PostgreSQLUUIDModel {}

extension Article: Content {}

extension Article: Migration {}

extension Article: Parameter {}
