//
//  NSManagedObject+RxSwift.swift
//  reactive-recipe-2
//
//  Created by krawiecp on 29/11/2015.
//  Copyright © 2015 Pawel Krawiec. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

extension NSManagedObjectContext {
    var rx_contextSaved: Observable<NSNotification> {
        get {
            return NSNotificationCenter.defaultCenter()
                .rx_notification(NSManagedObjectContextDidSaveNotification)
        }
    }
}