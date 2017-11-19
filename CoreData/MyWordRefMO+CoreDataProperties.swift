//
//  MyWordRefMO+CoreDataProperties.swift
//  FarsiEnglishDictionary
//
//  Created by Maryam Rajaei on 2017-11-16.
//  Copyright © 2017 veddes. All rights reserved.
//
//

import Foundation
import CoreData


extension MyWordRefMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyWordRefMO> {
        return NSFetchRequest<MyWordRefMO>(entityName: "MyWordRefrences")
    }

    @NSManaged public var english: String?
    @NSManaged public var farsi: String?
    @NSManaged public var isItFavorite: Bool
    @NSManaged public var itemNumber: Int16
    @NSManaged public var voice: NSData?
    @NSManaged public var toListFromDic: ListMO?

}
