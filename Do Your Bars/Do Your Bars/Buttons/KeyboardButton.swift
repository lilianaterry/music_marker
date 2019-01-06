//
//  KeyboardButton.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 1/2/19.
//  Copyright © 2019 Liliana Terry. All rights reserved.
//

import UIKit

class KeyboardButton: UIButton {

    let toolKit = UIExtensions()
    
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
    
    override func awakeFromNib() {
        commonInit()
    }
    
    func commonInit() {
        layer.backgroundColor = UIColor.white.cgColor
        layer.applyShadow(color: toolKit.shadow, alpha: 0.16, x: 0, y: 3, blur: 16, spread: 0)
    }
}

class CharKeyboardButton: KeyboardButton {
    
    func addItem(color: UIColor) -> NSAttributedString {
        let size = (self.titleLabel?.text?.isNumber)! ? toolKit.numSize : toolKit.barSize
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: size),
            .foregroundColor: color,
        ]
        return NSMutableAttributedString(string: (self.titleLabel?.text)!, attributes: attributes)
    }
}

class ColorKeyboardButton: KeyboardButton {
    
    var color: UIColor? { didSet { setNeedsDisplay() } }
    var selectedLayer: CALayer?
    var selectedPath: UIBezierPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSelectedLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSelectedLayer()
    }
    
    func addSelectedLayer() {
        self.selectedLayer = CALayer()
        self.layer.addSublayer(selectedLayer!)
    }
    
    func addColor(color: UIColor) {
        layer.backgroundColor = color.cgColor
        self.color = color
    }
    
    public func select() {
        self.isSelected = true
        setNeedsDisplay()
    }
    
    public func deselect() {
        self.isSelected = false
        self.selectedPath = nil
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        if self.isSelected {
            let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
            let radius = self.frame.width / 3
            let width = self.frame.width / 8
            
            self.selectedPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            
            self.selectedPath?.lineWidth = width
            UIColor.white.setStroke()
            self.selectedPath?.stroke()
        }
    }
    
}
