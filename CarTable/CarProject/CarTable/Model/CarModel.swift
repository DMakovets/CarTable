//
//  CarModel.swift
//  CarTable
//
//  Created by Denis Makovets on 2/21/20.
//  Copyright © 2020 Denis Makovets. All rights reserved.
//

import RealmSwift

class Cars: Object {
    
    @objc dynamic var model: String = ""
    @objc dynamic var mark: String?
    @objc dynamic var price: String?
    @objc dynamic var imageData: Data?
    
    convenience init(model: String, mark: String?, price: String?, imageData: Data?){
        self.init()
        self.model = model
        self.mark = mark
        self.price = price
        self.imageData = imageData
    }
    
}
