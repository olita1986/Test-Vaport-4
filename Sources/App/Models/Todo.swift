import Fluent
import Vapor

final class Todo: Model, Content {
    static let schema = "todos"
    
    @ID(key: "id")
    var id: Int?

    @Field(key: "title")
    var title: String

    init() { }

    init(id: Int? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

//extension Todo: Validatable {
//    static func validations(_ validations: inout Validations) {
//        validations.add("title", as: String.self, is: .email, required: true)
//    }
//}
