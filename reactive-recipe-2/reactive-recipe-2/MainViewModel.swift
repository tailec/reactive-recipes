//
//  MainViewModel.swift
//  reactive-recipe-2
//
//  Created by krawiecp on 28/11/2015.
//  Copyright © 2015 Pawel Krawiec. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

struct MainViewModel {
    
    let coreDataStack: CoreDataStack
    
    let title: Driver<String>
    let items: Observable<[Item]>
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        title = Drive.just("Not much to do")
        
        let request = NSFetchRequest(entityName: Item.entityName)
        let fetchedItems = try! CoreDataStack.defaultStack.context.executeFetchRequest(request) as! [Item]
        items = just(fetchedItems)

    }
    
}