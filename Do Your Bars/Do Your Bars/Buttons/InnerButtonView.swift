//
//  InnerButtonView.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 12/29/18.
//  Copyright © 2018 Liliana Terry. All rights reserved.
//

import UIKit

@IBDesignable class InnerButtonView: UIView, Button {
    
    var path: UIBezierPath!
    
    let colorPalette = UIExtensions()
    
    var text: String = "" { didSet { setNeedsDisplay() } }
    var clockwise: Bool = true { didSet { setNeedsDisplay() } }
    var textYMultiplyer: CGFloat = 0 { didSet { setNeedsDisplay() } }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        commonInit()
    }
    
    override func draw(_ rect: CGRect) {
        createSemiCircle()
        addLabel()
        UIColor.white.setFill()
        colorPalette.grey.setStroke()
        path.fill()
        path.lineWidth = 5.0
        path.stroke(with: .destinationIn, alpha: 0)
    }
    
    private func commonInit() {
        contentMode = .redraw
        backgroundColor = .clear
        isOpaque = false
    }

    private func createSemiCircle() {
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let radius = self.bounds.width / 2
        
        let startAngle = .pi as CGFloat
        let endAngle = 0 as CGFloat
        
        path = UIBezierPath()
        path.move(to: center)
        path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        path.close()        
    }
    
    private func addLabel() {
        let label = UILabel(frame: self.bounds)
        label.center = CGPoint(x: self.bounds.width / 2, y: textYMultiplyer * (self.bounds.width / 4))
        label.textAlignment = .center
        label.textColor = colorPalette.defaultText
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = text
        self.addSubview(label)
    }
    
    func addItem(prevChar: NSAttributedString) -> NSMutableAttributedString {
        let color: UIColor
        if prevChar.length > 0 {
            color = prevChar.attribute(.foregroundColor, at: 0, effectiveRange: nil) as! UIColor
        } else {
            color = colorPalette.black
        }
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: colorPalette.barSize),
            .foregroundColor: color,
            ]
        return NSMutableAttributedString(string: self.text, attributes: attributes)
    }
}
