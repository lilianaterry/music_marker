//
//  TestViewController.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 12/25/18.
//  Copyright © 2018 Liliana Terry. All rights reserved.
//

import Foundation
import UIKit

struct BarInput {
    var text: String
    var colorId: ColorId
    var size: CGFloat
}

protocol Button {
    var path: UIBezierPath! { get set }
    func addItem(barList: Array<BarInput>) -> BarInput
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var wheelView: UIView!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var barCollection: UICollectionView!
    var innerWheelView: UIView!
    
    let colorPalette = UIExtensions()
    
    var buttonList = Array<Button>()
    var barList = Array<BarInput>()
    
    var currBarCount: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSimonWheel()
        barView.layer.applyShadow(color: colorPalette.shadow, alpha: 0.16, x: 0, y: 4, blur: 4, spread: 0)
        barView.clipsToBounds = false
        
        currBarCount = 0
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
        return UITapGestureRecognizer(target: self, action: #selector(ViewController.tapDetected(tapRecognizer:)))
    }
    
    @objc public func tapDetected(tapRecognizer: UITapGestureRecognizer) {
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
        let newItem = button.addItem(barList: barList)
        
        if let prevItem = barList.last {
            // add empty item if new color added
            if (newItem.colorId != prevItem.colorId || currBarCount == 4) {
                barList.append(BarInput(text: "", colorId: newItem.colorId, size: 60))
                currBarCount = 0
            }
        }
        
        if newItem.text != "=" {
            currBarCount += 1
        }
        
        barList.append(newItem)
        barCollection.reloadData()
        barCollection.scrollToLast()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return barList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "barCell", for: indexPath) as! BarCollectionViewCell
        
        let bar = barList[indexPath.item]
        let textColor = UIColor.init(hex: bar.colorId.rawValue)
        
        cell.label.adjustsFontSizeToFitWidth = true
        cell.label.minimumScaleFactor = 0.5
        cell.label.text = bar.text
        cell.label.textColor = textColor
        
        return cell
    }
    
    // MARK - Number Buttons
    @IBAction func numberButtonPressed(_ sender: Any) {
        addBarItem(button: sender as! Button)
    }
    
}
