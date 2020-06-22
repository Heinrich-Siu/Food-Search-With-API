import UIKit

class ViewController: UIViewController {
    
    //storyBoard variables
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var serving: UILabel!
    @IBOutlet weak var resultTable: UITableView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var resultNumberText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setImage(from: "https://spoonacular.com/recipeImages/Gluten-Free-Chicken-Bruschetta--AD--CookItGF-593785.jpg")
        resultTable.dataSource = self
        stepper.value = 3.0 //for number of search returns
        
    }
    
    var resultArray : [FoodItem] = []
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.image.image = image
            }
        }
    }
    
    @IBAction func changeNumberOfResultsToReturn(_ sender: Any) {
        resultNumberText.text = "Search for \(Int(stepper.value)) results"
    }
    
    @IBAction func exitEdit(_ sender: Any) {
        view.endEditing(true) //dismiss keyboard
    }
    
    @IBAction func searchFood(_ sender: Any) {
        
        view.endEditing(true)
        if searchbar.text! != "" {
            let dishes = FoodSearch()
            resultArray = dishes.searchRecipie(name: searchbar.text!, resultNumber: Int(stepper.value))
            print(Int(stepper.value))
            name.text = "Name: \(resultArray[0].title)"
            time.text = "Time: \(resultArray[0].readyInMinutes) minutes"
            serving.text = "Serving for: \(resultArray[0].servings) people"
            resultTable.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "dishDetail"{
            let destinationVC = segue.destination as! DishDetailViewController
            
            if let indexPath = resultTable.indexPathForSelectedRow{
                let selectedRow = indexPath.row
                destinationVC.food = resultArray[selectedRow]
            }
        }
    }
    
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dishCell", for: indexPath)
        cell.textLabel?.text = String(resultArray[indexPath.row].title)
        return cell
    }
    
    
}

