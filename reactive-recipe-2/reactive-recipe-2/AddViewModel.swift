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
    
    // input
    var contentTextObservable = BehaviorSubject<String>(value: "")

    // output
    let cancelBarButtonItemTitle = "Cancel"
    let doneBarButtonItemTitle = "Done"
    var isContentValid: Observable<Bool> {
        return self.contentTextObservable
            .map {
                $0.characters.count == 0 ? false : true
            }
    }
    
    // private
    private let coreDataStack: CoreDataStack
    private let disposeBag = DisposeBag()
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func addItem() {
        let item = NSEntityDescription.insertNewObjectForEntityForName(Item.entityName, inManagedObjectContext: coreDataStack.context) as! Item
        _ = contentTextObservable.subscribeNext {
                item.content = $0
            }
            .addDisposableTo(disposeBag)
        
        item.done = false
        
        do {
            try coreDataStack.context.save()
        } catch {
            print("Failed to save to CoreData")
        }
    }
}