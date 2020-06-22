//
//  DishDetailView.swift
//  apiTest
//
//  Created by Heinrich Siu on 22/6/2020.
//  Copyright © 2020 Heinrich Siu. All rights reserved.
//

import UIKit

class DishDetailViewController: UIViewController {
    
    
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    var food : FoodItem?
    var ingredientArray : [ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsTableView.dataSource = self
        
        // Do any additional setup after loading the view.
        if food != nil{
            setImage(from: "https://spoonacular.com/recipeImages/\(food!.image)")
            
            dishName.text = food?.title
            ingredientArray = FoodSearch().findIngredients(id: food!.id)
            print(ingredientArray)
            
        }
        
    }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.dishImage.image = image
            }
        }
    }
    
    
    
}

extension DishDetailViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredientArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        cell.textLabel?.text = String(ingredientArray[indexPath.row].name)
        return cell
    }
    
    
}
