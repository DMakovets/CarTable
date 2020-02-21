//
//  MainViewController.swift
//  CarTable
//
//  Created by Denis Makovets on 2/21/20.
//  Copyright © 2020 Denis Makovets. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    let cars = [Cars(model: "X5", mark: "BMW", price: "32900", image: "X5"),
    Cars(model: "X6", mark: "BMW", price: "35900", image: "X6"),
    Cars(model: "X7", mark: "BMW", price: "40900", image: "X7"),
    Cars(model: "Q3", mark: "Audi", price: "27900", image: "Q3"),
    Cars(model: "Q5", mark: "Audi", price: "31900", image: "Q5"),
    Cars(model: "Q7", mark: "Audi", price: "33900", image: "Q7"),
    Cars(model: "PORTOFINO", mark: "Ferrari", price: "69900", image: "PORTOFINO"),
    Cars(model: "FF", mark: "Ferrari", price: "65900", image: "FF"),
    Cars(model: "CALIFORNIA", mark: "Ferrari", price: "63900", image: "CALIFORNIA")]

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
    
        cell.markLabel.text = cars[indexPath.row].model
        cell.makerLabel.text = cars[indexPath.row].mark
        cell.priceLabel.text = cars[indexPath.row].price
        cell.imageOfCar.image = UIImage(named: cars[indexPath.row].image)
        return cell
    }

 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancelAction(_ segue: UIStoryboardSegue){
        
    }
}
