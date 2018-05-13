import Vapor
import Leaf
import FluentPostgreSQL

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
    try services.register(FluentPostgreSQLProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a PostgreSQL database
    var databases = DatabasesConfig()
    let databaseConfig: PostgreSQLDatabaseConfig
    if let url = Environment.get("DATABASE_URL") {
        databaseConfig = try PostgreSQLDatabaseConfig(url: url)
    } else {
        let databaseName: String
        let databasePort: Int
        databaseName = Environment.get("DATABASE_DB") ?? "vapor_kindergarten"
        databasePort = 5432
        let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
        let username = Environment.get("DATABASE_USER") ?? "vapor_kindergarten"
        let password = Environment.get("DATABASE_PASSWORD") // Optional
        databaseConfig = PostgreSQLDatabaseConfig(
            hostname: hostname,
            port: databasePort,
            username: username,
            database: databaseName,
            password: password
        )

        print(databaseConfig)
    }
    let database = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .psql)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Article.self, database: .psql)
    migrations.add(model: User.self, database: .psql)
    services.register(migrations)

    var middlewareConfig = MiddlewareConfig.default()
    middlewareConfig.use(SessionsMiddleware.self)
    services.register(middlewareConfig)
    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)

    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
}
