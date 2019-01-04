//
//  TestViewController.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 12/25/18.
//  Copyright © 2018 Liliana Terry. All rights reserved.
//

import Foundation
import UIKit

protocol Button {
    var path: UIBezierPath! { get set }
    func addItem(prevChar: NSAttributedString) -> NSMutableAttributedString
}

class ViewController: UIViewController {
    
    @IBOutlet weak var wheelView: UIView!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var barTextView: UITextView!
    
    var currBarCount: Int!
    
    var innerWheelView: UIView!
    
    var buttonList = Array<Button>()
    
    let colorPalette = UIExtensions()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        setupBarView()
        createSimonWheel()
        
        currBarCount = 0
    }
    
    func setupBarView() {
        let tappedView = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewTapDetected))
        
        barView.addGestureRecognizer(tappedView)
        barView.layer.applyShadow(color: colorPalette.shadow, alpha: 0.16, x: 0, y: 4, blur: 8, spread: 0)
        barView.clipsToBounds = false
        barView.layer.cornerRadius = 10
        
        barTextView.scrollToTop()
        barTextView.textContainerInset = UIEdgeInsets.zero
        barTextView.attributedText = NSMutableAttributedString()
    }
    
    // MARK: - Wheel
    func createSimonWheel() {
        // 1 - Create view for inner buttons
        let innerViewSize = CGSize(width: wheelView.frame.width * 0.36, height: wheelView.frame.height * 0.36)
        let innerFrame = CGRect(origin: wheelView.frame.origin, size: innerViewSize)
        innerWheelView = UIView(frame: innerFrame)
        wheelView.addSubview(innerWheelView)
        innerWheelView.center = wheelView.convert(wheelView.center, to: innerWheelView)
        
        innerWheelView.backgroundColor = .clear
        wheelView.backgroundColor = .clear
        
        // 2 - Add wedge buttons
        addWedgeView(color: colorPalette.blue, angle: 0, colorId: ColorId.blue)
        addWedgeView(color: colorPalette.black, angle: 0.5 * .pi, colorId: ColorId.black)
        addWedgeView(color: colorPalette.green, angle: .pi, colorId: ColorId.green)
        addWedgeView(color: colorPalette.red, angle: 1.5 * .pi, colorId: ColorId.red)
        
        // 3 - Add inner buttons
        addSemiCircleShadow()
        addSemiCircleView(clockwise: false, text: "?", textYMultiplier: 3, shadow: false)
        addSemiCircleView(clockwise: true, text: "=", textYMultiplier: 1, shadow: false)
    }
    
    func addWedgeView(color: UIColor, angle: Radians, colorId: ColorId) {
        let wedgeView = SimonWedgeView(frame: wheelView.bounds)
        wedgeView.fillColor = color
        wedgeView.centerAngle = angle
        wedgeView.colorId = colorId
        wedgeView.addGestureRecognizer(setGestureRecognizer())
        
        wheelView.addSubview(wedgeView)
        buttonList.append(wedgeView)
    }
    
    func addSemiCircleView(clockwise: Bool, text: String, textYMultiplier: CGFloat, shadow: Bool) {
        let semiCircleView = InnerButtonView(frame: innerWheelView.frame)
        semiCircleView.text = text
        semiCircleView.clockwise = clockwise
        semiCircleView.textYMultiplyer = textYMultiplier
        
        semiCircleView.addGestureRecognizer(setGestureRecognizer())
        
        innerWheelView.addSubview(semiCircleView)
        semiCircleView.center = innerWheelView.convert(innerWheelView.center, to: semiCircleView)
        buttonList.append(semiCircleView)
    }
    
    func addSemiCircleShadow() {
        let topAndBottom = [InnerButtonView(frame: innerWheelView.frame), InnerButtonView(frame: innerWheelView.frame)]

        topAndBottom[0].clockwise = true
        topAndBottom[1].clockwise = false
        
        for view in topAndBottom {
            view.layer.applyShadow(color: colorPalette.shadow, alpha: 0.25, x: 0, y: 4, blur: 12, spread: 0)
            innerWheelView.addSubview(view)
            view.center = innerWheelView.convert(innerWheelView.center, to: view)
        }
    }
    
    func setGestureRecognizer() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(ViewController.buttonTapDetected(tapRecognizer:)))
    }
    
    @objc public func buttonTapDetected(tapRecognizer: UITapGestureRecognizer) {
        let outerTapLocation: CGPoint = tapRecognizer.location(in: self.wheelView)
        let innerTapLocation: CGPoint = tapRecognizer.location(in: self.innerWheelView)

        for button in buttonList {
            let tapLocation = button is SimonWedgeView ? outerTapLocation : innerTapLocation
            if (self.hitTest(tapLocation: tapLocation, button: button)) {
                addBarItem(button: button)
                break
            }
        }
    }
    
    private func hitTest(tapLocation: CGPoint, button: Button) -> Bool {
        if (button.path.contains(tapLocation)) {
            return true
        }
        return false
    }
    
    // MARK: - Bar Collection
    private func addBarItem(button: Button) {
        let currString = barTextView.attributedText.mutableCopy() as! NSMutableAttributedString
        let newItem = button.addItem(prevChar: currString.last())
        
        // check if a space is needed
        if barTextView.attributedText.length > 0 {
            let currColor = newItem.attribute(.foregroundColor, at: newItem.length - 1, effectiveRange: nil) as! UIColor
            let prevColor = currString.attribute(.foregroundColor, at: currString.length - 1, effectiveRange: nil) as! UIColor
            
            // add empty space if new color added or four bars of the same color have occured
            if (currColor != prevColor || (currBarCount == 4 && newItem.string != "=")) {
                currString.append(NSAttributedString(string: "  "))
                currBarCount = 0
            }
        }
        
        currBarCount = newItem.string != "=" ? currBarCount + 1 : 0
        
        currString.append(newItem)
        barTextView.attributedText = currString
        barTextView.scrollToBottom()
    }
    
    // MARK - Number Buttons
    @IBAction func numberButtonPressed(_ sender: Any) {
        addBarItem(button: sender as! Button)
    }
    
    
    // MARK - Segue to Edit
    @IBAction func deleteSelected(_ sender: Any) {
        barTextView.attributedText = NSAttributedString()
    }
    
    @IBAction func undoSelected(_ sender: Any) {
        barTextView.attributedText = barTextView.attributedText.removeLast()
    }
    
    @IBAction func editSelected(_ sender: Any) {
        performSegue(withIdentifier: "editSegue", sender: self)
    }
    
    @objc public func viewTapDetected() {
        performSegue(withIdentifier: "editSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC : EditViewController = segue.destination as! EditViewController
        destVC.barText = barTextView.attributedText.mutableCopy() as! NSMutableAttributedString
    }
}
