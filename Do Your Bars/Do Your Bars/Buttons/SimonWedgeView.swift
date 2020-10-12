//
//  CustomButton.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 12/25/18.
//  Copyright © 2018 Liliana Terry. All rights reserved.
//  Credit to Rob Mayoff

import UIKit

typealias Radians = CGFloat

enum ColorId: Int {
    case blue = 0x5595FF
    case red = 0xEB4973
    case green = 0x2BD88A
    case black = 0x333D4E
}

extension UIBezierPath {
    
    static func simonWedge(innerRadius: CGFloat, outerRadius: CGFloat, centerAngle: Radians, gap: CGFloat) -> UIBezierPath
    {
        let innerAngle: Radians = CGFloat.pi / 4 - gap / (2 * innerRadius)
        let outerAngle: Radians = CGFloat.pi / 4 - gap / (2 * outerRadius)
        let path = UIBezierPath()
        path.lineJoinStyle = CGLineJoin.round
        path.addArc(withCenter: .zero, radius: innerRadius, startAngle: centerAngle - innerAngle, endAngle: centerAngle + innerAngle, clockwise: true)
        path.addArc(withCenter: .zero, radius: outerRadius, startAngle: centerAngle + outerAngle, endAngle: centerAngle - outerAngle, clockwise: false)
        path.close()
        return path
    }
    
}

class SimonWedgeView: UIControl, Button {
    
    var wedgePath: UIBezierPath!
    var wedgeBorder: CAShapeLayer!
    let toolKit = UIExtensions()
    
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
    var colorId: ColorId?
    
    override func draw(_ rect: CGRect) {
        createWedgePath()
        fillColor.setFill()
        wedgePath.fill()
    }
    
    private func commonInit() {
        contentMode = .redraw
        backgroundColor = .clear
        isOpaque = false
    }
    
    private func createWedgePath() {
        let bounds = self.bounds
        
        let outerRadius = min(bounds.size.width, bounds.size.height) / 2
        let innerRadius = outerRadius / 2
        let gap = (outerRadius - innerRadius) / 4
        
        wedgePath = UIBezierPath.simonWedge(innerRadius: innerRadius, outerRadius: outerRadius, centerAngle: centerAngle, gap: gap)
        wedgePath.apply(CGAffineTransform(translationX: bounds.midX, y: bounds.midY))
        
        wedgePath.lineWidth = 5
        wedgePath.lineCapStyle = CGLineCap.round
        
        wedgeBorder = CAShapeLayer()
        wedgeBorder.path = wedgePath.cgPath // Reuse the Bezier path
        wedgeBorder.fillColor = UIColor.clear.cgColor
        wedgeBorder.strokeColor = UIColor.white.cgColor
        wedgeBorder.lineWidth = 5
        wedgeBorder.lineCap = CAShapeLayerLineCap.round
        wedgeBorder.frame = self.bounds
        wedgeBorder.lineJoin = CAShapeLayerLineJoin.round
        self.layer.addSublayer(wedgeBorder)
        
        self.layer.applyShadow(color: toolKit.shadow, alpha: 0.16, x: 0, y: 6, blur: 4, spread: 0)
    }
    
    func addItem(prevChar: NSAttributedString) -> NSMutableAttributedString {
        let color = UIColor.init(hex: (self.colorId?.rawValue)!)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.monospacedDigitSystemFont(ofSize: toolKit.barSize, weight: UIFont.Weight.bold),
            .foregroundColor: color,
        ]
        return NSMutableAttributedString(string: "I", attributes: attributes)
    }
}

