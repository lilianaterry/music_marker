//
//  CustomButton.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 12/25/18.
//  Copyright © 2018 Liliana Terry. All rights reserved.
//

import UIKit
@IBDesignable

class ColorButton: UIView {
    
    var shapePath = UIBezierPath()
    
    @IBInspectable var color: UIColor = UIColor.gray
    
    private struct Constants {
        static let width: CGFloat = 115;
        static let height: CGFloat = 230;
    }
    
    override func draw(_ rect: CGRect) {
        // 1
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        // 2
        let radius: CGFloat = bounds.height
        
        // 3
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = .pi / 2
        
        // 4
        shapePath = UIBezierPath(arcCenter: center,
                                radius: radius/2 - CGFloat(Constants.width/2),
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        // 5
        shapePath.lineWidth = Constants.width / 2
        color.setStroke()
        shapePath.stroke()
        shapePath.close()
    }
}
