//
//  ListMO+CoreDataProperties.swift
//  FarsiEnglishDictionary
//
//  Created by Maryam Rajaei on 2017-11-16.
//  Copyright © 2017 veddes. All rights reserved.
//
//

import Foundation
import CoreData


extension ListMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListMO> {
        return NSFetchRequest<ListMO>(entityName: "List")
    }

    @NSManaged public var listingName: String?
    @NSManaged public var listingNumber: Int16
    @NSManaged public var toDicFromList: NSSet?

}

// MARK: Generated accessors for toDicFromList
extension ListMO {

    @objc(addToDicFromListObject:)
    @NSManaged public func addToToDicFromList(_ value: MyWordRefMO)

    @objc(removeToDicFromListObject:)
    @NSManaged public func removeFromToDicFromList(_ value: MyWordRefMO)

    @objc(addToDicFromList:)
    @NSManaged public func addToToDicFromList(_ values: NSSet)

    @objc(removeToDicFromList:)
    @NSManaged public func removeFromToDicFromList(_ values: NSSet)

}
