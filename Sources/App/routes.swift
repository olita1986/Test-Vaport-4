import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req in
        return Todo(id: 1, title: "hello")
    }
    
    app.get(":number") { req -> String in
        guard let number = req.parameters.get("number", as: Int.self) else {
            throw Abort.init(.badRequest)
        }
        return "Hola, tengo \(number) años"
    }
    
    

//    let todos = app.grouped("todos")
    let todoController = TodoController()
//    todos.get(use: todoController.index)
//    todos.post(use: todoController.create)
//    todos.delete(":todoID", use: todoController.delete)
    
    try app.register(collection: todoController)
    
    
    let heroController = HeroController()
    try app.register(collection: heroController)
}
