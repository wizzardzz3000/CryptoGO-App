//
//  CoreDataStore.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 03/03/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CDHandler: NSObject {
    
    class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // Wallet functions
    //------------------
    
    class func saveObject(cryptosInfo: CryptosMOInfo) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "CryptosMO", in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(cryptosInfo.name, forKey: "name")
        managedObject.setValue(cryptosInfo.code, forKey: "code")
        managedObject.setValue(cryptosInfo.symbol, forKey: "symbol")
        managedObject.setValue(cryptosInfo.placeholder, forKey: "placeholder")
        managedObject.setValue(cryptosInfo.amount, forKey: "amount")
        managedObject.setValue(cryptosInfo.amountValue, forKey: "amountValue")
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func fetchObject() -> [CryptosMO]? {
        let context = getContext()
        var cryptos: [CryptosMO]? = nil
        
        do {
            cryptos = try context.fetch(CryptosMO.fetchRequest()) as? [CryptosMO]
            return cryptos
        } catch {
            return cryptos
        }
    }

    
    class func deleteObject(entity: String, deleteObject: NSManagedObject) {
        let context = getContext()
        context.delete(deleteObject)
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    class func editObject(editObject: NSManagedObject, amount: String, amountValue: String) {
        let context = getContext()
        let managedObject = editObject
        
        do {
            managedObject.setValue(amount, forKey: "amount")
            managedObject.setValue(amountValue, forKey: "amountValue")
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // News Cell Functions
    //---------------------
    class func saveSource(name:String, link:String) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "NewsCellMO", in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(name, forKey: "name")
        managedObject.setValue(link, forKey: "link")
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    class func fetchSource() -> [NewsCellMO]? {
        let context = getContext()
        var cryptos: [NewsCellMO]? = nil
        
        do {
            cryptos = try context.fetch(NewsCellMO.fetchRequest()) as? [NewsCellMO]
            return cryptos
        } catch {
            return cryptos
        }
    }
    class func deleteSource(entity: String, deleteObject: NSManagedObject) {
        let context = getContext()
        context.delete(deleteObject)
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
