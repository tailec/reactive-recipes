//
//  AddViewModel.swift
//  reactive-recipe-2
//
//  Created by krawiecp on 29/11/2015.
//  Copyright © 2015 Pawel Krawiec. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

struct AddViewModel {
    let coreDataStack: CoreDataStack
    
    let cancelBarButtonItemTitle = "Cancel"
    let doneBarButtonItemTitle = "Done"
    
    var contentText: Observable<String>?
    var isContentValid: Observable<Bool> {
        get {
            if let contentText = contentText {
                return contentText
                    .map { $0.characters.count > 0 }
                
            } else {
                return just(false)
            }
        }
    }
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func addItem() {
        let item = NSEntityDescription.insertNewObjectForEntityForName(Item.entityName, inManagedObjectContext: coreDataStack.context) as! Item
        _ = contentText?.subscribeNext {
            item.content = $0
        }
        item.done = false
        
        do {
            try coreDataStack.context.save()
        } catch {
            print("Failed to save to CoreData")
        }
    }
}