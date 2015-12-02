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
    var searchTextObservable = PublishSubject<String>()
    
    // Output
    var contentChangesObservable = PublishSubject<[Item]>()
    var titleObservable = PublishSubject<String>()
    
    // Private
    private var coreDataStack: CoreDataStack
    private let disposeBag = DisposeBag()
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        super.init()
        
        _ = didBecomeActive.map { _ in
                MainViewModel.getItemsWithStack(self.coreDataStack)
            }
            .bindTo(contentChangesObservable)
        
        
        _ = self.searchTextObservable
            .filter {
                $0.characters.count > 0
            }
            .map { text in
                let fetchRequest = NSFetchRequest(entityName: Item.entityName)
                fetchRequest.predicate = NSPredicate(format: "content CONTAINS[cd] %@", text)
                return try! self.coreDataStack.context.executeFetchRequest(fetchRequest) as! [Item]
            }
            .bindTo(contentChangesObservable)
        
        _ = self.searchTextObservable
            .filter {
                $0.characters.count == 0
            }
            .map { text in
                MainViewModel.getItemsWithStack(self.coreDataStack)
            }
            .bindTo(contentChangesObservable)
        
    }
    
    func addViewModel() -> AddViewModel {
        return AddViewModel(coreDataStack: coreDataStack)
    }
}

extension MainViewModel {
    private static func getItemsWithStack(stack: CoreDataStack) -> [Item] {
        return try! stack.context.executeFetchRequest(NSFetchRequest(entityName: Item.entityName)) as! [Item]
    }
}