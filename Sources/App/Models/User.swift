import Foundation
import Vapor
import FluentPostgreSQL

final class User: Codable {
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
