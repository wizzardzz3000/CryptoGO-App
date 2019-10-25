//
//  CryptosMO+CoreDataProperties.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 03/03/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//
//

import Foundation
import CoreData


extension CryptosMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CryptosMO> {
        return NSFetchRequest<CryptosMO>(entityName: "CryptosMO")
    }

    @NSManaged public var amountValue: String
    @NSManaged public var amount: String?
    @NSManaged public var code: String?
    @NSManaged public var name: String?
    @NSManaged public var placeholder: String?
    @NSManaged public var symbol: String?
}
