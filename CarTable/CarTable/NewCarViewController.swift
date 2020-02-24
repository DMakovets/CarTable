//
//  NewCarViewController.swift
//  CarTable
//
//  Created by Denis Makovets on 2/21/20.
//  Copyright © 2020 Denis Makovets. All rights reserved.
//

import UIKit
import RealmSwift

class NewCarViewController: UITableViewController {
    
    
    var imageIsChanged = false
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var modelCar: UITextField!
    @IBOutlet weak var markCar: UITextField!
    @IBOutlet weak var priceCar: UITextField!
    
    override func viewDidLoad() {
        
        saveButton.isEnabled = false
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        modelCar.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    //MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let camera  = UIAlertAction(title: "Camera", style: .default) { (_) in
                self.chooseImagePicker(source: .camera)
            }
            let photo = UIAlertAction(title: "Photo", style: .default) { (_) in
                self.chooseImagePicker(source: .photoLibrary)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true)
            
        }else{
            view.endEditing(true)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
}



//MARK: Text field delegate

extension NewCarViewController: UITextFieldDelegate {
    // Hide keyboard when press Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged(){
        if modelCar.text?.isEmpty == false {
            saveButton.isEnabled = true
        }else{
            saveButton.isEnabled = false
        }
    }
    
    func saveNewCar(){
        
        var image: UIImage?
        
        if imageIsChanged {
            image = carImage.image
        }else{
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        let imageData = image?.pngData()
        let newCar = Cars(model: modelCar.text!, mark: markCar.text!, price: priceCar.text!, imageData: imageData)
        CarsManager.saveObject(newCar)
    }
}

//MARK: Work with image

extension NewCarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func chooseImagePicker(source: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        carImage.image = info[.editedImage] as? UIImage
        carImage.contentMode = .scaleAspectFill
        carImage.clipsToBounds = true
        imageIsChanged = true
        dismiss(animated: true)
    }
}

