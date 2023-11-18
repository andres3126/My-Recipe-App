//
//  DessertViewController.swift
//  My Recipe App
//
//  Created by Andres Duque Valencia on 7/11/23.
//

import UIKit
import AlamofireImage

class DessertViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var desserts = [[String:Any]]()
    var filteredDesserts = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 120
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self

        let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                self.desserts = dataDictionary["meals"] as! [[String:Any]]
                self.desserts.sort { (first, second) -> Bool in
                    let firstTitle = first["strMeal"] as? String ?? ""
                    let secondTitle = second["strMeal"] as? String ?? ""
                    return firstTitle < secondTitle
                }

                self.filteredDesserts = self.desserts // Initialize filteredDesserts with all desserts initially

                self.tableView.reloadData()
            }
        }
        task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDesserts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DessertsCell") as! DessertsCell
        let dessert = filteredDesserts[indexPath.row]

        if let recipeTitle = dessert["strMeal"] as? String {
            cell.tittleLabel.text = recipeTitle
        }

        if let dessertImage = dessert["strMealThumb"] as? String, let dessertURL = URL(string: dessertImage) {
            cell.dessertView.af.setImage(withURL: dessertURL)
        }

        return cell
    }
    
    // UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterDesserts(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // Helper method to filter desserts
    func filterDesserts(_ searchText: String) {
        if searchText.isEmpty {
            // If the search bar is empty, show all desserts
            filteredDesserts = desserts
        } else {
            // Filter desserts based on the search text
            filteredDesserts = desserts.filter {
                ($0["strMeal"] as? String)?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }

        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Find the selected dessert
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let dessert = filteredDesserts[indexPath.row]
        
        // Pass the selected dessert
        
        let detailsViewController = segue.destination as! DessertDetailsViewController
        detailsViewController.filteredDessert = dessert
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

