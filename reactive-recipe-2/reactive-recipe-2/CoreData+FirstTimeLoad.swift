//
//  CoreData+FirstTimeLoad.swift
//  reactive-recipe-2
//
//  Created by krawiecp on 28/11/2015.
//  Copyright © 2015 Pawel Krawiec. All rights reserved.
//

import Foundation
import CoreData

extension CoreDataStack {
    func loadFirstTimeData() {
        guard isFirstTimeDataExists() == false else {
            return
        }
        
        for (index, itemContent) in ["Walk out dog", "Wash car"].enumerate() {
            let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context) as! Item
            item.content = itemContent
            item.position = index
        }
        do {
            try context.save()
        } catch {
            print("Failed to save to CoreData")
        }
        
    }
    
    // better solution?
    private func isFirstTimeDataExists() -> Bool {
        let request = NSFetchRequest(entityName: Item.entityName)
        let fetchedItems = try! context.executeFetchRequest(request) as! [Item]
        return !fetchedItems.isEmpty
    }
}