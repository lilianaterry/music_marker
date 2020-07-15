//
//  DataTransformer.swift
//  
//
//  Created by Liliana Terry on 7/14/20.
//

import Foundation
import UIKit

class AttributedStringToData: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        let storedData = try! NSKeyedArchiver.archivedData(withRootObject: value!, requiringSecureCoding: true)
        return storedData
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        let attributedString = value as! Data
        let data = try! NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSAttributedString.self], from: attributedString)
        return (data as! NSAttributedString)
    }
}
