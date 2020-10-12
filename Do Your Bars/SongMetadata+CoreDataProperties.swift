//
//  SongMetadata+CoreDataProperties.swift
//  
//
//  Created by Liliana Terry on 10/11/20.
//
//

import Foundation
import CoreData


extension SongMetadata {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SongMetadata> {
        return NSFetchRequest<SongMetadata>(entityName: "SongMetadata")
    }

    @NSManaged public var song: String?
    @NSManaged public var artist: String?
    @NSManaged public var album: String?
    @NSManaged public var time: String?

}
