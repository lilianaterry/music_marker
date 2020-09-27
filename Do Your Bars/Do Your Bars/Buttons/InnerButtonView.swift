//
//  InnerButtonView.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 12/29/18.
//  Copyright © 2018 Liliana Terry. All rights reserved.
//

import UIKit

@IBDesignable class InnerButtonView: UIControl, Button {
    
    var wedgePath: UIBezierPath!
    
    let toolKit = UIExtensions()
    
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
        toolKit.grey.setStroke()
        wedgePath.fill()
        wedgePath.lineWidth = 5.0
        wedgePath.stroke(with: .destinationIn, alpha: 0)
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
        
        wedgePath = UIBezierPath()
        wedgePath.move(to: center)
        wedgePath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        wedgePath.close()        
    }
    
    private func addLabel() {
        let label = UILabel(frame: self.bounds)
        label.center = CGPoint(x: self.bounds.width / 2, y: textYMultiplyer * (self.bounds.width / 4))
        label.textAlignment = .center
        label.textColor = toolKit.defaultText
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = text
        self.addSubview(label)
    }
    
    func addItem(prevChar: NSAttributedString) -> NSMutableAttributedString {
        let color: UIColor
        if prevChar.length > 0 {
            color = prevChar.attribute(.foregroundColor, at: 0, effectiveRange: nil) as! UIColor
        } else {
            color = toolKit.black
        }
        if (self.text == "?") {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: toolKit.barSize),
                .foregroundColor: color,
                ]
            return NSMutableAttributedString(string: self.text, attributes: attributes)
        } else {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: toolKit.numSize),
                .foregroundColor: color,
                ]
            return NSMutableAttributedString(string: self.text, attributes: attributes)
        }

    }
}
