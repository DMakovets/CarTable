//
//  MainViewController.swift
//  CarTable
//
//  Created by Denis Makovets on 2/21/20.
//  Copyright © 2020 Denis Makovets. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var cars: Results<Cars>!
    private var filteredCars: Results<Cars>!
    private var ascendingSorting = true
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    @IBOutlet weak var reversSortingButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cars = realm.objects(Cars.self)
        
        //Setup Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering{
            return filteredCars.count
        }
        return cars.isEmpty ? 0 : cars.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        
        var carsSearch = Cars()
        
        if isFiltering {
            carsSearch = filteredCars[indexPath.row]
        }else{
            carsSearch = cars[indexPath.row]
        }
        
        cell.markLabel.text = carsSearch.model
        cell.makerLabel.text = carsSearch.mark
        cell.priceLabel.text = carsSearch.price
        cell.imageOfCar.image = UIImage(data: carsSearch.imageData!)
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let car = cars[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
            CarsManager.deleObject(car)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deleteAction]
    }
    
    
    //MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let car: Cars
            if isFiltering{
                car = filteredCars[indexPath.row]
            }else{
                car = cars[indexPath.row]
            }
            let newCarVC = segue.destination as! NewCarViewController
            newCarVC.currentCar = car
        }
    }
    
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue){
        guard let newCarVC = segue.source as? NewCarViewController else {return}
        
        newCarVC.saveCar()
        tableView.reloadData()
    }
    
    @IBAction func reversedSerting(_ sender: Any) {
        ascendingSorting.toggle()
        if ascendingSorting {
            reversSortingButton.image = #imageLiteral(resourceName: "AZ")
        }else{
            reversSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        sorting()
    }
    
    private func sorting(){
        cars = cars.sorted(byKeyPath: "price", ascending: ascendingSorting)
        tableView.reloadData()
    }
    
}

extension MainViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    private func filterContentForSearchText(_ searchText: String){
        filteredCars = cars.filter("model CONTAINS[c] %@ OR mark CONTAINS[c] %@", searchText, searchText)
        tableView.reloadData()
    }
    
}
