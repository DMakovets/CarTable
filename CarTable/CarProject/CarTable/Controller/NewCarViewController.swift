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
    
    var currentCar: Cars?
    var imageIsChanged = false
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var modelCar: UITextField!
    @IBOutlet weak var markCar: UITextField!
    @IBOutlet weak var priceCar: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        tableView.tableFooterView = UIView()
        modelCar.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
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
            
            let sharePhoto = UIAlertAction(title: "Share", style: .default) { (_) in
                self.sharedPhoto()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(sharePhoto)
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true)
            
        }else{
            view.endEditing(true)
        }
    }
    
    private func setupEditScreen(){
        if currentCar != nil{
            
            setupNavigationBar()
            imageIsChanged = true
            guard let data = currentCar?.imageData, let image = UIImage(data:data) else {return}
            carImage.image = image
            carImage.contentMode = .scaleAspectFill
            modelCar.text = currentCar?.model
            markCar.text = currentCar?.mark
            priceCar.text = currentCar?.price
        }
    }
    
    private func setupNavigationBar(){
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentCar?.model
        saveButton.isEnabled = true
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
    
    func saveCar(){
        
        var image: UIImage?
        
        if imageIsChanged {
            image = carImage.image
        }else{
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        let imageData = image?.pngData()
        let newCar = Cars(model: modelCar.text!, mark: markCar.text!, price: priceCar.text!, imageData: imageData)
        if currentCar != nil {
            try! realm.write {
                currentCar?.model = newCar.model
                currentCar?.mark = newCar.mark
                currentCar?.price = newCar.price
                currentCar?.imageData = newCar.imageData
            }
            
        }else{
            CarsManager.saveObject(newCar)
        }
    }
}

//MARK: Work with image

extension NewCarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func chooseImagePicker(source: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
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
    func sharedPhoto(){
        guard let data = currentCar?.imageData, let image = UIImage(data:data) else {return}
        let shareController = UIActivityViewController(activityItems: [image] , applicationActivities: nil)
        present(shareController, animated: true,completion:  nil)
    }
}

