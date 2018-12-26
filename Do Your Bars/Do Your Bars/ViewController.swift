//
//  TestViewController.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 12/25/18.
//  Copyright © 2018 Liliana Terry. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var blueButton: ColorButton!
    @IBOutlet weak var redButton: ColorButton!
    @IBOutlet weak var greenButton: ColorButton!
    @IBOutlet weak var blackButton: ColorButton!
    
    var buttonList: Array<ColorButton>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
        buttonList = [blueButton, redButton, greenButton, blackButton]
        
        blueButton.color = UIColor.blue
        redButton.color = UIColor.red
        greenButton.color = UIColor.green
        blackButton.color = UIColor.black
        
        for button in buttonList {
            button.setNeedsDisplay()
        }
        
        // 2
        for button in buttonList {
            button.addGestureRecognizer(setGestureRecognizer())
            button.isUserInteractionEnabled = true
        }
    }
    
    func setGestureRecognizer() -> UIGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(ViewController.tapDetected(tapRecognizer:)))
    }
    
    @objc public func tapDetected(tapRecognizer:UITapGestureRecognizer) {
        print("******** tap detected *********")
        var missed = true
        for button in buttonList {
            let tapLocation:CGPoint = tapRecognizer.location(in: button)
            if (self.hitTest(tapLocation: CGPoint(x: tapLocation.x, y: tapLocation.y), button: button)) {
                missed = false
                break
            }
        }
        
        if (missed) {
            print ("missed")
        }
    }
    
    private func hitTest(tapLocation:CGPoint, button: ColorButton) -> Bool {
        let path:UIBezierPath = button.shapePath
        let pathCopy:CGPath = path.cgPath.copy(strokingWithWidth: path.lineWidth, lineCap: CGLineCap(rawValue: 0)!, lineJoin: CGLineJoin(rawValue: 0)!, miterLimit: 1)
        
        if (path.contains(tapLocation) || pathCopy.contains(tapLocation)) {
            if button.color == UIColor.black {
                print("hit black")
            } else if button.color == UIColor.green {
                print("hit green")
            } else if button.color == UIColor.blue {
                print("hit blue")
            } else if button.color == UIColor.red {
                print("hit red")
            }
            return true
        } else{
            return false
        }
    }
    
}
