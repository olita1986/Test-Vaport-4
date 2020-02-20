import Fluent
import Vapor

struct TodoController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("todos")
        todos.get(use: index)
        todos.get(":id", use: byId)
        todos.delete(":todoID", use: delete)
        todos.post(use: create)
        todos.patch(":id", use: update)
    }
    
    func index(req: Request) throws -> EventLoopFuture<[Todo]> {
        return Todo.query(on: req.db).all()
    }
    
    func byId(req: Request) throws -> EventLoopFuture<Todo> {
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }
        return Todo.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    func create(req: Request) throws -> EventLoopFuture<Todo> {
//        try Todo.validate(req)
        let todo = try req.content.decode(Todo.self)
        return todo.save(on: req.db).map { todo }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func update(req: Request) throws -> EventLoopFuture<Todo> {
        let updatedTodo = try req.content.decode(Todo.self)
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }
        return Todo.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { todo -> EventLoopFuture<Todo> in
                todo.title = updatedTodo.title
                return todo.save(on: req.db).map { todo }
            }
    }
}
