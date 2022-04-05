//
//  CoreDataStack.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 01/04/2022.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    let persistanceContainer: NSPersistentContainer
    
    var context : NSManagedObjectContext {
        get {
            persistanceContainer.viewContext.mergePolicy = NSMergePolicy.overwrite
            return persistanceContainer.viewContext
        }
    }
    
    private init() {
        persistanceContainer = NSPersistentContainer(name: "MovieDB")
        persistanceContainer.loadPersistentStores{ description, error in
            if let error = error {
                fatalError("Core Data store failed to load with error: \(error)")
            }
        }
    }
    
    func saveContext() {
        let context = self.context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
