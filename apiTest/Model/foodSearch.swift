import Foundation

struct FoodSearch{
    
    
    
    
    let baseURL = "https://api.spoonacular.com/recipes/"
    let apiKey = "apiKey=6444653bda864e518d832ad8f5b110c2"
    
    func searchRecipie(name : String, resultNumber : Int) -> [FoodItem]{
        
        //forms URL
        var urlString = baseURL
        urlString.append(contentsOf: "search?query=\(name)&number=\(resultNumber)&")
        urlString.append(contentsOf: apiKey)
        
        var output: [FoodItem] = []
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                //let dataAsString = String(data: data!, encoding: .utf8) for debugging
                if let safeData = data {
                    output = self.parseJSON(safeData)
                    
                }
            }
            
            task.resume()
            
        }
        while output.isEmpty {
            continue
        }
        return output
        
    }
    
    func findIngredients(id : Int) -> [ingredient] {
        
        var urlString = baseURL
        urlString.append(contentsOf: "\(id)/ingredientWidget.json/?\(apiKey)")
        print(urlString)
        
        var output: [ingredient] = []
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                //let dataAsString = String(data: data!, encoding: .utf8)
                //print(dataAsString) debugging
                if let safeData = data {
                    output = self.parseIngredientJSON(safeData)
                    
                }
            }
            
            task.resume()
            
        }
        while output.isEmpty {
            continue
        }
        return output
    }
    
    
    
    
    
    func parseJSON(_ data: Data) -> [FoodItem] {
        
        //Create a JSONDecoder
        let decoder = JSONDecoder()
        do {
            
            let decodedData = try decoder.decode(FoodItems.self, from: data)
            return decodedData.results
            
        } catch {
            
            print(error)
            return []
            
        }
    }
    func parseIngredientJSON(_ data: Data) -> [ingredient] {
        
        //Create a JSONDecoder
        let decoder = JSONDecoder()
        do {
            
            let decodedData = try decoder.decode(ingredients.self, from: data)
            return decodedData.ingredients
            
        } catch {
            
            print(error)
            return []
            
        }
    }
}
