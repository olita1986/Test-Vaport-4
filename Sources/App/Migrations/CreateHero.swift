import Fluent

struct CreateHero: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("heroes")
            .field("id", .int, .identifier(auto: true))
            .field("name", .string, .required)
            .field("strength", .int, .required)
            .field("defense", .int, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("heroes").delete()
    }
}
