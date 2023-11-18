//
//  DessertDetailsViewController.swift
//  My Recipe App
//
//  Created by Andres Duque Valencia on 17/11/23.
//

import UIKit
import AlamofireImage

class DessertDetailsViewController: UIViewController {

    @IBOutlet weak var dessertView: UIImageView!
    @IBOutlet weak var dessertTitle: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    var filteredDessert: [String: Any]!

        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            // Title label
            dessertTitle.text = filteredDessert["strMeal"] as? String
            
            // Image set up
            if let dessertImage = filteredDessert["strMealThumb"] as? String, let dessertURL = URL(string: dessertImage) {
                dessertView.af.setImage(withURL: dessertURL)
            }
            
            
            fetchDessertDetails()
            
            
            
            }
    
    
    func fetchDessertDetails() {
            guard let idMeal = filteredDessert["idMeal"] as? String else {
                return
            }
            
            let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(idMeal)")!
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    if let meals = dataDictionary["meals"] as? [[String: Any]], let detailedDessert = meals.first {
                        self.updateUI(with: detailedDessert)
                    }
                }
            }
            
            task.resume()
        }
    
    func updateUI(with detailedDessert: [String: Any]) {
        
        var ingredientsText = "Ingredients:\n"
            
            for i in 1...20 { // Assuming a maximum of 20 ingredients, adjust as needed
                if let ingredient = detailedDessert["strIngredient\(i)"] as? String,
                   !ingredient.isEmpty,
                   let measure = detailedDessert["strMeasure\(i)"] as? String,
                   !measure.isEmpty {
                    ingredientsText += "\(i). \(ingredient) - \(measure)\n"
                }
            }
            
            ingredientsLabel.text = ingredientsText

            
            if let instructions = detailedDessert["strInstructions"] as? String {
                descriptionLabel.text = "Instructions: \(instructions)"
                descriptionLabel.sizeToFit()
            }

       }
    }
