//
//  NewsCellMO+CoreDataProperties.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 13/03/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//
//

import Foundation
import CoreData


extension NewsCellMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsCellMO> {
        return NSFetchRequest<NewsCellMO>(entityName: "NewsCellMO")
    }

    @NSManaged public var name: String
    @NSManaged public var link: String 

}
