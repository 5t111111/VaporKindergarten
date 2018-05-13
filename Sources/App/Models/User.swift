import Foundation
import Vapor
import Fluent
import FluentPostgreSQL
import Authentication

struct User: Codable {
    var id: UUID?
    var email: String
    var password: String

    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

extension User: Content {}

extension User: PostgreSQLUUIDModel {}

extension User: Migration {}

extension User: BasicAuthenticatable {
    static let usernameKey = \User.email
    static let passwordKey = \User.password
}
