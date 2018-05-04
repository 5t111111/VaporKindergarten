import Vapor
import Leaf
import FluentMySQL

/// Called before your application initializes.
///
/// https://docs.vapor.codes/3.0/getting-started/structure/#configureswift
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    /// Register providers first
    try services.register(LeafProvider())
    try services.register(FluentMySQLProvider())

    config.prefer(LeafRenderer.self, for: TemplateRenderer.self)

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(DateMiddleware.self) // Adds `Date` header to responses
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a MySQL database
    let mySQLDatabaseConfig = MySQLDatabaseConfig(
        hostname: "127.0.0.1",
        port: 3306,
        username: "vapor_kindergarten",
        password: "vapor_kindergarten",
        database: "vapor_kindergarten"
    )
    let mysql = MySQLDatabase(config: mySQLDatabaseConfig)

    /// Register the configured MySQL database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: mysql, as: .mysql)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Article.self, database: .mysql)
    services.register(migrations)
}
