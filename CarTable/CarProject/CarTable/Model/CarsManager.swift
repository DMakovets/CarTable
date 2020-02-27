 //
 //  CarsManager.swift
 //  CarTable
 //
 //  Created by Denis Makovets on 2/24/20.
 //  Copyright © 2020 Denis Makovets. All rights reserved.
 //
 
 import RealmSwift
 
 let realm = try! Realm()
 
 class CarsManager {
    
    static func saveObject(_ cars: Cars){
        try! realm.write{
            realm.add(cars)
        }
    }
    
    static func deleObject(_ cars: Cars){
        try! realm.write{
            realm.delete(cars)
        }
    }
    
 }
 
