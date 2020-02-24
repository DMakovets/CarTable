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

    var cars: Results<Cars>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cars = realm.objects(Cars.self)
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.isEmpty ? 0 : cars.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
    
        let car = cars[indexPath.row]
        cell.markLabel.text = car.model
        cell.makerLabel.text = car.mark
        cell.priceLabel.text = car.price
        cell.imageOfCar.image = UIImage(data: car.imageData!)
      
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

    @IBAction func unwindSegue(_ segue: UIStoryboardSegue){
        guard let newCarVC = segue.source as? NewCarViewController else {return}
        newCarVC.saveNewCar()

        tableView.reloadData()
    }
}
