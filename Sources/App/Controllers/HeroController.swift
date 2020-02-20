import Vapor
import Fluent

struct HeroController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let heroes = routes.grouped("heroes")
        heroes.get(use: index)
        heroes.get(":id", use: findById)
        heroes.post(use: indexQueryParams)
        heroes.delete(":id", use: delete)
        heroes.patch(":id", use: update)
    }
    
    // GET /heroes
    func index(req: Request) throws -> EventLoopFuture<[Hero]> {
        return Hero.query(on: req.db).all()
    }
    
    // POST /heroes
//    func create(req: Request) throws -> EventLoopFuture<Hero> {
//        let hero = try req.content.decode(Hero.self)
//        return hero.save(on: req.db).map { hero }
//    }
    
    func indexQueryParams(req: Request) throws -> EventLoopFuture<Hero> {
        let hero = try req.query.decode(Hero.self)
        return hero.save(on: req.db).map { hero }
    }
    
    // GET /heroes/:id
    func findById(req: Request) throws -> EventLoopFuture<Hero> {
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }
        return Hero.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    // DELETE /heroes/:id
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Hero.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.badRequest))
            .flatMap { hero in
                return hero.delete(on: req.db)
            }
            .transform(to: .ok)
    }
    
    // PATCH /heroes/:id
    func update(req: Request) throws ->  EventLoopFuture<Hero> {
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }
        let updatedHero = try req.content.decode(Hero.self)
        return Hero.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { hero -> EventLoopFuture<Hero> in
                hero.name = updatedHero.name
                hero.strength = updatedHero.strength
                hero.defense = updatedHero.defense
                return hero.update(on: req.db).map { hero }
            }
    }
}


