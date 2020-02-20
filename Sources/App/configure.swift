import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.middleware.use(LogMiddleware())

    app.databases.use(.sqlite(.memory), as: .sqlite)

    app.migrations.add(CreateTodo())
    app.migrations.add(CreateHero())
    try app.autoMigrate().wait()

    // register routes
    try routes(app)
}
