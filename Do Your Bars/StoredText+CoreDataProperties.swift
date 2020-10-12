//
//  StoredText+CoreDataProperties.swift
//  
//
//  Created by Liliana Terry on 10/11/20.
//
//

import Foundation
import CoreData


extension StoredText {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredText> {
        return NSFetchRequest<StoredText>(entityName: "StoredText")
    }

    @NSManaged public var attributedText: NSAttributedString?

}
