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
    let grey = UIColor.init(hex: 0xDAE0EA)

    // depth
    let shadow = UIColor.init(hex: 0x1B407E)
    let background = UIColor.init(hex: 0xF2F2F7)
    let header_background = UIColor.init(hex: 0xE9EEF4)
    
    // text colors
    let header = UIColor.init(hex: 0x667B9D)
    let subheader = UIColor.init(hex: 0xDBE0E6)
    let defaultText = UIColor.init(hex: 0x007AFF)
    
    // text size
    let barSize = 40.0 as CGFloat
    let numSize = 30.0 as CGFloat
    
    // button text size
    let numButtonTextSize = 20.0 as CGFloat
    
    // text
    let space = NSAttributedString(string: "  ")
    let total = "Total: "
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

extension UICollectionView {
    func scrollToLast() {
        guard numberOfSections > 0 else {
            return
        }
        
        let lastSection = numberOfSections - 1
        
        guard numberOfItems(inSection: lastSection) > 0 else {
            return
        }
        
        let lastItemIndexPath = IndexPath(item: numberOfItems(inSection: lastSection) - 1,
                                          section: lastSection)
        scrollToItem(at: lastItemIndexPath, at: .right, animated: false)
    }
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

extension UITextView {
    func scrollToTop() {
        let textCount: Int = text.count
        guard textCount >= 1 else { return }
        scrollRangeToVisible(NSMakeRange(0, 1))
    }
    
    func scrollToBottom() {
        let textCount: Int = text.count
        guard textCount >= 1 else { return }
        scrollRangeToVisible(NSMakeRange(textCount - 1, 1))
    }
}

extension NSAttributedString {
    func removeLast() -> NSAttributedString {
        let length: Int = self.length
        let newRange: NSRange = NSMakeRange(0, length - 1)
        return self.attributedSubstring(from: newRange)
    }
    
    func last() -> NSAttributedString {
        guard self.length > 0 else { return NSAttributedString() }
        return self.attributedSubstring(from: NSRange(location: self.length - 1, length: 1))
    }
    
    func removeWhiteSpace() -> NSAttributedString {
        var string = self
        while (string.length > 0 && string.string.suffix(1) == " ") {
            string = string.removeLast()
        }
        return string
    }
}

extension UIControl {
  func animate(_ button: UIControl) {
      var transform = CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95)
      UIView.animate(withDuration: 0.1,
                     delay: 0,
                     usingSpringWithDamping: 0.5,
                     initialSpringVelocity: 0.5,
                     options: [.curveEaseInOut],
                     animations: {
                        button.transform = transform
          }, completion: nil)
      
      transform = .identity
      UIView.animate(withDuration: 0.1,
                     delay: 0.1,
                     usingSpringWithDamping: 0.5,
                     initialSpringVelocity: 0.5,
                     options: [.curveEaseInOut],
                     animations: {
                        button.transform = transform
          }, completion: nil)
  }
}
