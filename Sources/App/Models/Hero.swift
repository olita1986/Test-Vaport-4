import Vapor
import Fluent

final class Hero: Model, Content {
    static let schema: String = "heroes"
    
    @ID(key: "id")
    var id: Int?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "strength")
    var strength: Int
    
    @Field(key: "defense")
    var defense: Int
    
    init() {}
    
    init(id: Int? = nil, name: String, strength: Int, defense: Int) {
        self.name = name
        self.defense = defense
        self.strength = strength
    }
    
    
}
