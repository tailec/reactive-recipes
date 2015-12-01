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
import RxViewModel
import CoreData

class MainViewModel: RxViewModel {

    // Input
    var searchTextObservable: Observable<String>
    
    // Output
    var contentChangesObservable: Observable<[Item]>!
    let titleObservable: Observable<String>
    
    // Private
    private var coreDataStack: CoreDataStack
    private var items: [Item] = []
    
    private let disposeBag = DisposeBag()
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.searchTextObservable = just("")
        //self.contentChangesObservable = just(MainViewModel.getItemsWithStack(coreDataStack))
        self.titleObservable = just("")
        
        super.init()
        _ = didBecomeActive.subscribeNext { _ in
            self.items = MainViewModel.getItemsWithStack(self.coreDataStack)
        }
        _ = self.didBecomeInactive.subscribeNext { _ in
            print("inactive")
        }
        self.forwardSignalWhileActive(contentChangesObservable.map {_ in
            return MainViewModel.getItemsWithStack(self.coreDataStack)
        })
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func selectItemAtIndexPath(indexPath: NSIndexPath) {
        let items = MainViewModel.getItemsWithStack(coreDataStack)
        items[indexPath.item].done = !(items[indexPath.item].done as! Bool)
        saveContext(coreDataStack.context)
    }
    
    func removeItemAtIndexPath(indexPath: NSIndexPath) {
        let items = MainViewModel.getItemsWithStack(coreDataStack)
        coreDataStack.context .deleteObject(items[indexPath.item])
        saveContext(coreDataStack.context)
    }
    
    func addViewModel() -> AddViewModel {
        return AddViewModel(coreDataStack: coreDataStack)
    }
    
    private func saveContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Failed to save to CoreData")
        }
    }
}

extension MainViewModel {
    private static func getItemsWithStack(stack: CoreDataStack) -> [Item] {
        return try! stack.context.executeFetchRequest(NSFetchRequest(entityName: Item.entityName)) as! [Item]
    }
}