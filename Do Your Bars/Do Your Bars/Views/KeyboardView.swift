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
    var currColor: UIColor?

    let symbolButtons: [CharKeyboardButton] = (0...2).map { (index) in
        let symbols = "I=?" as String
        let strIndex = symbols.index(symbols.startIndex, offsetBy: index)
        
        let button = CharKeyboardButton(type: .system)
        button.accessibilityTraits = [.keyboardKey]
        button.setTitle(String(symbols[strIndex]), for: .normal)
        button.tag = index
        button.titleLabel?.font = UIFont(name:"SFProDisplay-Bold", size: UIExtensions().numButtonTextSize)
        
        return button
    }
    
    let colorButtons: [ColorKeyboardButton] = (0...3).map { (index) in
        let toolKit = UIExtensions()
        let colors = [toolKit.black, toolKit.blue, toolKit.green, toolKit.red]
        
        let button = ColorKeyboardButton(type: .custom)
        button.accessibilityTraits = [.keyboardKey]
        button.addColor(color: colors[index])
        
        return button
    }
    
    let numberButtons: [CharKeyboardButton] = (1...7).map { (index) in
        let button = CharKeyboardButton(type: .system)
        button.accessibilityTraits = [.keyboardKey]
        button.setTitle(String(index), for: .normal)
        button.titleLabel?.font = UIFont(name:"SFProDisplay-Bold", size: UIExtensions().numButtonTextSize)
        return button
    }
    
    var spaceButton: SpaceKeyboardButton = {
        let space = SpaceKeyboardButton(type: .system)
        let spaceSymbolChar = 0x2423
        space.setTitle(String(UnicodeScalar(spaceSymbolChar)!), for: .normal)
        space.titleLabel?.font = space.titleLabel?.font.withSize(25)
        return space
    }()
    
    let backspaceButton: BackspaceKeyboardButton = {
        let backspace = BackspaceKeyboardButton(type: .system)
        let delSymbolChar = 0x232B
        backspace.setTitle(String(UnicodeScalar(delSymbolChar)!), for: .normal)
        backspace.titleLabel?.font = backspace.titleLabel?.font.withSize(25)
        return backspace
    }()
    
    var allButtons: [KeyboardButton]?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    func changeColor(color: UIColor) {
        if currColor != color {
            currColor = color
            for button in colorButtons {
                if button.color != color {
                    button.deselect()
                }
            }
        }
    }
    
    func addTextViewDelegate(delegate: AnyObject) {
        for button in symbolButtons {
            button.delegate = delegate
        }
        
        for button in numberButtons {
            button.delegate = delegate
        }
        
        spaceButton.delegate = delegate
        backspaceButton.delegate = delegate
    }
}

// MARK: - Private action methods
private extension KeyboardView {
    @objc func buttonTapped(_ sender: AnyObject) {
        let recognizer = sender as! UITapGestureRecognizer
        let button = recognizer.view as! KeyboardButton
        button.isPressed()
    }
}

// MARK: - Private initial configuration methods
private extension KeyboardView {
    func configure() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // setup keyboard colors and instance variables
        self.backgroundColor = UIExtensions().background
        let currColorButton = colorButtons[0]
        currColorButton.select()
        currColor = currColorButton.color
        
        allButtons = symbolButtons + colorButtons + numberButtons
        allButtons?.append(spaceButton)
        allButtons?.append(backspaceButton)
    
        addButtons()
        configureButtons()
    }
    
    /// Adds a gesture recognizer to each button
    func configureButtons() {
        for button in allButtons! {
            addGestureRecognizer(button: button)
        }
        
        for button in colorButtons {
            button.delegate = self
        }
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
                for column in 0 ..< 7 {
                    button = numberButtons[column]
                    constrainButton(button: button)
                    subStackView.addArrangedSubview(button)
                }
                break
            case 2: // colored/action buttons
                // colors
                for column in 0 ..< 4 {
                    button = colorButtons[column]
                    button.delegate = self
                    constrainButton(button: button)
                    subStackView.addArrangedSubview(button)
                }
                // space and backspace
                constrainButton(button: spaceButton)
                constrainButton(button: backspaceButton)
                subStackView.addArrangedSubview(spaceButton)
                subStackView.addArrangedSubview(backspaceButton)
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
    
    func addGestureRecognizer(button: KeyboardButton) {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        button.addGestureRecognizer(recognizer)
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
