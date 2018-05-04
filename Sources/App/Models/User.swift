import Vapor
import FluentMySQL

final class User: MySQLModel {
    var id: Int?
    var email: String
    var password: String

    init(id: Int? = nil, email: String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }
}

extension User: Content {}

extension User: Migration {}
