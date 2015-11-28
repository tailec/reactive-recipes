//
//  Item+CoreDataProperties.swift
//  
//
//  Created by krawiecp on 28/11/2015.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var content: String?
    @NSManaged var position: NSNumber?

}
