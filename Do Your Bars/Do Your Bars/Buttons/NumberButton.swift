//
//  NumberButton.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 12/29/18.
//  Copyright © 2018 Liliana Terry. All rights reserved.
//

import UIKit

@IBDesignable class NumberButton: UIButton, Button {
    
    var path: UIBezierPath!
    
    let colorPalette = UIExtensions()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        commonInit()
    }
    
    func commonInit() {
        layer.backgroundColor = UIColor.white.cgColor
        layer.cornerRadius = frame.width / 2
        layer.applyShadow(color: colorPalette.shadow, alpha: 0.16, x: 0, y: 3, blur: 16, spread: 0)
        path = UIBezierPath()
    }
    
    func addItem(prevChar: NSAttributedString) -> NSMutableAttributedString {
        let color: UIColor
        if prevChar.length > 0 {
            color = prevChar.attribute(.foregroundColor, at: 0, effectiveRange: nil) as! UIColor
        } else {
            color = colorPalette.black
        }
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: colorPalette.numSize),
            .foregroundColor: color,
        ]
        return NSMutableAttributedString(string: (self.titleLabel?.text)!, attributes: attributes)
    }
}
