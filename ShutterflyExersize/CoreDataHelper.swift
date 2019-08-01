//
//  CoreDataHelper.swift
//  ShutterflyExersize
//
//  Created by Red Pill on 22.08.2018.
//  Copyright © 2018 ideveloper. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper {
    static let shared = CoreDataHelper()
    private init() {}
    
    //MARK: -
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "photos")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveURL(_ urlStr: String?) {
        guard let urlStr = urlStr else { return }
        
        DispatchQueue.main.async {
            let context: NSManagedObjectContext = self.persistentContainer.viewContext
            
            let photo = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as! Photo
            photo.url = urlStr
            
            self.saveContext()
            print("Saved in Core Data")
        }
    }
}
