import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
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
    
    var resultArray : [FoodItem] = []
    var selectedRow : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setImage(from: "https://spoonacular.com/recipeImages/Gluten-Free-Chicken-Bruschetta--AD--CookItGF-593785.jpg")//initial image
        resultTable.dataSource = self
        resultTable.delegate = self
        stepper.value = 3.0 //for number of search returns
        
    }
    
    
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
    
    @IBAction func searchFood(_ sender: Any) {
        
        view.endEditing(true)
        if searchbar.text! != "" {
            let dishes = FoodSearch()
            resultArray = dishes.searchRecipie(name: searchbar.text!, resultNumber: Int(stepper.value))
            updateDish(index: 0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "dishDetail"{
            let destinationVC = segue.destination as! DishDetailViewController
            destinationVC.food = resultArray[selectedRow ?? 0]
            /*
            if let indexPath = resultTable.indexPathForSelectedRow{
                let selectedRow = indexPath.row
                print(indexPath.row)
                destinationVC.food = resultArray[selectedRow]
            }
 */
        }
    }
    
    func updateDish(index: Int){
        name.text = "Name: \(resultArray[index].title)"
        time.text = "Time: \(resultArray[index].readyInMinutes) minutes"
        serving.text = "Serving for: \(resultArray[index].servings) people"
        print(resultArray[index].image)
        setImage(from: "https://spoonacular.com/recipeImages/"+resultArray[index].image)
        resultTable.reloadData()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateDish(index: indexPath.row)
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        selectedRow = indexPath.row
        performSegue(withIdentifier: "dishDetail", sender: nil)
        return nil
    }
    
    
    
}

