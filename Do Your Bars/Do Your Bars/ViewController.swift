//
//  TestViewController.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 12/25/18.
//  Copyright © 2018 Liliana Terry. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable

class ViewController: UIViewController {
    
    @IBOutlet weak var rootView: UIView!
    
    var wedgeList = Array<SimonWedgeView>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSimonWheel()
    }
    
    func createSimonWheel() {
        rootView.backgroundColor = .clear
        
        addWedgeView(color: UIColor.blue, angle: 0, colorId: Color.blue)
        addWedgeView(color: UIColor.black, angle: 0.5 * .pi, colorId: Color.black)
        addWedgeView(color: UIColor.green, angle: .pi, colorId: Color.green)
        addWedgeView(color: UIColor.red, angle: 1.5 * .pi, colorId: Color.red)
    }
    
    func addWedgeView(color: UIColor, angle: Radians, colorId: Color) {
        let wedgeView = SimonWedgeView(frame: rootView.bounds)
        wedgeView.fillColor = color
        wedgeView.centerAngle = angle
        wedgeView.colorId = colorId
        wedgeView.addGestureRecognizer(setGestureRecognizer())
        
        rootView.addSubview(wedgeView)
        wedgeList.append(wedgeView)
    }
    
    func setGestureRecognizer() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(ViewController.tapDetected(tapRecognizer:)))
    }
    
    @objc public func tapDetected(tapRecognizer: UITapGestureRecognizer) {
        let tapLocation: CGPoint = tapRecognizer.location(in: rootView)
        
        for wedge in wedgeList {
            if (self.hitTest(tapLocation: CGPoint(x: tapLocation.x, y: tapLocation.y), wedge: wedge)) {
                addBar(wedge: wedge)
                break
            }
        }
    }
    
    private func hitTest(tapLocation: CGPoint, wedge: SimonWedgeView) -> Bool {
        let pathCopy: CGPath = wedge.path.cgPath.copy(strokingWithWidth: wedge.path.lineWidth, lineCap: CGLineCap(rawValue: 0)!, lineJoin: CGLineJoin(rawValue: 0)!, miterLimit: 1)
        
        if (wedge.path.contains(tapLocation) || pathCopy.contains(tapLocation)) {
            return true
        }
        return false
    }
    
    private func addBar(wedge: SimonWedgeView) {
        print(wedge.colorId.debugDescription)
    }
}
