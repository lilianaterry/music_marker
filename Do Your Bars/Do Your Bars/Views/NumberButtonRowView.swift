//
//  NumberButtonRowView.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 11/10/19.
//  Copyright © 2019 Liliana Terry. All rights reserved.
//

import UIKit

protocol NumberButtonDelegate: AnyObject {
    func addBarItem(button: Button)
}

class NumberButtonRowView: UIControl {

    var delegate: NumberButtonDelegate!
    
    // asthetics
    let internalPadding = 10.0 as CGFloat
    var buttonSize = 50.0 as CGFloat

    let toolkit = UIExtensions()

    let numberButtons: [NumberButton] = (1...7).map { (index) in
        let numberStr = String(index)
        
        let button = NumberButton(type: .system)
        button.accessibilityTraits = [.keyboardKey]
        button.setTitle(numberStr, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Bold", size: UIExtensions().numButtonTextSize)
        button.tag = index
        
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
    
    func configure() {
        // setup keyboard colors and instance variables
        self.backgroundColor = UIColor.clear
       
        layoutButtonSubviews()
        configureButtons()
    }
       
    func configureButtons() {
        for button in numberButtons {
            addGestureRecognizer(button: button)
        }
    }
    
    func addGestureRecognizer(button: NumberButton) {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        button.addGestureRecognizer(recognizer)
    }
    
    @objc func buttonTapped(_ sender: AnyObject) {
        let recognizer = sender as! UITapGestureRecognizer
        let button = recognizer.view as! Button
        (button as! UIControl).animate(button as! UIControl)
        delegate.addBarItem(button: button)
    }
       
    func layoutButtonSubviews() {
        let buttonSize: CGFloat = self.bounds.height
        var currX: CGFloat = 0.0
        let currY: CGFloat = 0.0
        for button in numberButtons {
            let buttonFrame = CGRect(x: currX, y: currY, width: buttonSize, height: buttonSize)
            button.frame = buttonFrame
            button.layer.cornerRadius = buttonSize / 2
            self.addSubview(button)
            currX += buttonSize + internalPadding
        }
    }
}

