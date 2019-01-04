//
//  KeyboardButton.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 1/2/19.
//  Copyright © 2019 Liliana Terry. All rights reserved.
//

import UIKit

class KeyboardButton: UIButton {

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
    }
}
