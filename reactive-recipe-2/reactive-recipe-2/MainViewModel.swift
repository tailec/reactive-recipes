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
    
    var title: Observable<String>
    var items: Observable<[Item]>
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        
        items = coreDataStack.context.rx_contextSaved.map {_ in
            return MainViewModel.getItemsWithStack(coreDataStack)
            }.startWith(MainViewModel.getItemsWithStack(coreDataStack))

        title = items.map {
            "(\($0.count))"
        }
    }
    
    func selectItemAtIndexPath(indexPath: NSIndexPath) {
        
    }
    
    func addViewModel() -> AddViewModel {
        return AddViewModel(coreDataStack: coreDataStack)
    }
    
    static private func getItemsWithStack(stack: CoreDataStack) -> [Item] {
        return try! stack.context.executeFetchRequest(NSFetchRequest(entityName: Item.entityName)) as! [Item]
    }
}