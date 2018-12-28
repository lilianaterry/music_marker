//
//  CustomButton.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 12/25/18.
//  Copyright © 2018 Liliana Terry. All rights reserved.
//  Credit to Rob Mayoff

import UIKit

typealias Radians = CGFloat

enum Color {
    case blue
    case red
    case green
    case black
}

extension UIBezierPath {
    
    static func simonWedge(innerRadius: CGFloat, outerRadius: CGFloat, centerAngle: Radians, gap: CGFloat) -> UIBezierPath
    {
        let innerAngle: Radians = CGFloat.pi / 4 - gap / (2 * innerRadius)
        let outerAngle: Radians = CGFloat.pi / 4 - gap / (2 * outerRadius)
        let path = UIBezierPath()
        path.addArc(withCenter: .zero, radius: innerRadius, startAngle: centerAngle - innerAngle, endAngle: centerAngle + innerAngle, clockwise: true)
        path.addArc(withCenter: .zero, radius: outerRadius, startAngle: centerAngle + outerAngle, endAngle: centerAngle - outerAngle, clockwise: false)
        path.close()
        return path
    }
    
}

class SimonWedgeView: UIView {
    
    var path: UIBezierPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        commonInit()
    }
    
    var centerAngle: Radians = 0 { didSet { setNeedsDisplay() } }
    var fillColor: UIColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1) { didSet { setNeedsDisplay() } }
    var colorId: Color?
    
    override func draw(_ rect: CGRect) {
        createWedgePath()
        fillColor.setFill()
        path.fill()
    }
    
    private func commonInit() {
        contentMode = .redraw
        backgroundColor = .clear
        isOpaque = false
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return UIBezierPath(ovalIn: bounds).contains(point)
    }
    
    private func createWedgePath() {
        let bounds = self.bounds
        let outerRadius = min(bounds.size.width, bounds.size.height) / 2
        let innerRadius = outerRadius / 2
        let gap = (outerRadius - innerRadius) / 4
        path = UIBezierPath.simonWedge(innerRadius: innerRadius, outerRadius: outerRadius, centerAngle: centerAngle, gap: gap)
        path.apply(CGAffineTransform(translationX: bounds.midX, y: bounds.midY))
    }
}

