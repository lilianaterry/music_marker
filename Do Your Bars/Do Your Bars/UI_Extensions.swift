//
//  UI_Extensions.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 5/16/18.
//  Copyright © 2018 Liliana Terry. All rights reserved.
//

import UIKit

class UIExtensions {
    // main color pallete
    let red = UIColor.init(hex: 0xEB4973)
    let blue = UIColor.init(hex: 0x5595FF)
    let green = UIColor.init(hex: 0x2BD88A)
    let black = UIColor.init(hex: 0x333D4E)

    // depth
    let shadow = UIColor.init(hex: 0x1B407E)
    let background = UIColor.init(hex: 0xF9FBFD)
    let header_background = UIColor.init(hex: 0xF9FBFD)

    
    // text colors
    let header = UIColor.init(hex: 0x667B9D)
    let subheader = UIColor.init(hex: 0xDBE0E6)

}

// create UI color from hex code
extension UIColor {
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
}

// add shadow to anything
extension CALayer {
    func applyShadow(
        color: UIColor,
        alpha: Float,
        x: CGFloat,
        y: CGFloat,
        blur: CGFloat,
        spread: CGFloat)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

// add bottom border to text
extension UIView {
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "underline"
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
}
