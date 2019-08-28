//
//  KeyboardView.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 8/15/19.
//  Copyright © 2019 Liliana Terry. All rights reserved.
//

import UIKit

protocol ColorDelegate: AnyObject {
    func changeColor(color: UIColor)
}

class KeyboardView: UIView, ColorDelegate {
    
    // asthetics
    let externalPadding = 16.0 as CGFloat
    let internalPadding = 10.0 as CGFloat
    var buttonSize = 50.0 as CGFloat
    
    let toolkit = UIExtensions()
    
    // actual attributes
    var currColor: UIColor = UIColor.clear

    var symbolButtons: [CharKeyboardButton] = (0...2).map { (index) in
        let symbols = "I=?" as String
        let strIndex = symbols.index(symbols.startIndex, offsetBy: index)
        
        let button = CharKeyboardButton(type: .system)
        button.accessibilityTraits = [.keyboardKey]
        button.setTitle(String(symbols[strIndex]), for: .normal)
        
        return button
    }
    
    var colorButtons: [ColorKeyboardButton] = (0...3).map { (index) in
        let toolKit = UIExtensions()
        let colors = [toolKit.black, toolKit.blue, toolKit.green, toolKit.red]
        
        let button = ColorKeyboardButton(type: .system)
        button.accessibilityTraits = [.keyboardKey]
        button.addColor(color: colors[index])
        
        return button
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    func changeColor(color: UIColor) {
        currColor = color
    }
}

// MARK: - Private initial configuration methods
private extension KeyboardView {
    func configure() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.backgroundColor = UIExtensions().background
        addButtons()
    }
    
    /// Adds all buttons to the keyboard in a vertical stack of horizontal stack rows
    func addButtons() {
        let paddedOrigin = CGPoint(x: self.bounds.minX + externalPadding, y: self.bounds.minY + externalPadding)
        let paddedSize = CGSize(width: self.bounds.width - (2 * externalPadding), height: self.bounds.height - (2 * externalPadding))
        let paddedFrame = CGRect(origin: paddedOrigin, size: paddedSize)
        
        let stackView = createStackView(axis: .vertical)
        stackView.frame = paddedFrame
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = internalPadding
        addSubview(stackView)   // now it's on the main Keyboard View
        
        // calculate button size
        buttonSize = (stackView.frame.width - 6 * internalPadding) / 7
        
        var button: KeyboardButton

        for row in 0 ..< 3 {
            let subStackView = createStackView(axis: .horizontal)
            subStackView.alignment = .center
            subStackView.spacing = internalPadding

            switch row {
            case 0: // character buttons
                for column in 0 ..< 3 {
                    button = symbolButtons[column]
                    constrainButton(button: button)
                    subStackView.addArrangedSubview(button)
                }
                break
            case 1: // numbered buttons
                for column in 1 ... 7 {
                    button = CharKeyboardButton(type: .system)
                    button.setTitle(String(column), for: .normal)
                    constrainButton(button: button)
                    subStackView.addArrangedSubview(button)
                }
                break
            case 2: // colored/action buttons
                for column in 0 ..< 4 {
                    button = colorButtons[column]
                    constrainButton(button: button)
                    button.delegate = self
                    subStackView.addArrangedSubview(button)
                    constrainButton(button: button)
                    subStackView.addArrangedSubview(button)
                }
                let space = KeyboardButton(type: .system)
                let backspace = KeyboardButton(type: .system)
                let delSymbolChar = 0x232B;
                backspace.setTitle(String(UnicodeScalar(delSymbolChar)!), for: .normal)
                space.setTitle(String("␣"), for: .normal)
                constrainButton(button: space)
                constrainButton(button: backspace)
                subStackView.addArrangedSubview(space)
                subStackView.addArrangedSubview(backspace)
                break
            default:
                print("error, case not found")
            }
            
            stackView.addArrangedSubview(subStackView)
        }
    }
    
    func constrainButton(button: KeyboardButton) {
        let widthConstraint = NSLayoutConstraint(
            item: button,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: buttonSize)
        let aspectConstraint = NSLayoutConstraint(
            item: button,
            attribute: .height,
            relatedBy: .equal,
            toItem: button,
            attribute: .width,
            multiplier: 1.0,
            constant: 0)
        aspectConstraint.priority = UILayoutPriority.defaultHigh
        
        button.addConstraint(widthConstraint)
        button.addConstraint(aspectConstraint)
        
        button.layer.cornerRadius = buttonSize / 2
    }

    
    /// Used to create a new stack view when building keyboard
    ///
    /// - Parameter axis: horizontal or vertical
    /// - Returns: newly created stack view
    func createStackView(axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        return stackView
    }
}
