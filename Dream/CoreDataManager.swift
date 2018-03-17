//
//  CoreDataManager.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 17.02.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    // MARK: - Constants
    
    static let sharedInstance = CoreDataManager()
    
    fileprivate let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Methods
    
    public func addDream(uuid: String, name: String, startDate: Date, targetDate: Date, currentCredits: Double, targetCredits: Double, image: Data, info: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Dream", in: self.managedObjectContext) else {
            print("CoreDataManager: add entity error")
            
            return
        }

        let dream = NSManagedObject(entity: entity, insertInto: self.managedObjectContext)
        
        dream.setValue(uuid,           forKeyPath: "uuid"          )
        dream.setValue(name,           forKeyPath: "name"          )
        dream.setValue(startDate,      forKeyPath: "startDate"     )
        dream.setValue(targetDate,     forKeyPath: "targetDate"    )
        dream.setValue(currentCredits, forKeyPath: "currentCredits")
        dream.setValue(targetCredits,  forKeyPath: "targetCredits" )
        dream.setValue(image,          forKeyPath: "image"         )
        dream.setValue(info,           forKeyPath: "info"          )
    }
    
    public func addTransaction(uuid: String, dream: Dream, date: Date, credits: Double) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: self.managedObjectContext) else {
            print("CoreDataManager: add entity error")
            
            return
        }
        
        let transaction  = NSManagedObject(entity: entity, insertInto: self.managedObjectContext)
        
        transaction.setValue(uuid,    forKeyPath: "uuid"    )
        transaction.setValue(date,    forKeyPath: "date"    )
        transaction.setValue(dream,   forKeyPath: "dream"   )
        transaction.setValue(credits, forKeyPath: "credits" )
    }
    
    public func fetchDreams() -> [Dream] {
        
        let fetchRequest = NSFetchRequest<Dream>(entityName: "Dream")
        
        do {
            let dreams = try self.managedObjectContext.fetch(fetchRequest)
            return dreams
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return [Dream]()
    }
    
    public func deleteDream(_ object: Dream) {
        self.managedObjectContext.delete(object)
    }
    
    public func saveContext() {
        if self.managedObjectContext.hasChanges {
            do {
                try self.managedObjectContext.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
}
