import Foundation
struct FoodItems: Decodable{
    var results : [FoodItem]
}
struct FoodItem: Decodable {
    let id : Int
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let sourceUrl: String
    let image: String //image url
}

