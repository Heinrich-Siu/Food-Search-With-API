import Foundation

struct ingredients: Decodable{
    var ingredients: [ingredient]
}

struct ingredient: Decodable {
    let name : String
    let image: String
}
