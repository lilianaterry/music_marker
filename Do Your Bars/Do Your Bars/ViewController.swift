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
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var barCollection: UICollectionView!
    
    let colorPalette = UIExtensions()
    
    var wedgeList = Array<SimonWedgeView>()
    var barList = Array<BarInput>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSimonWheel()
    }
    
    // MARK: - Wheel
    func createSimonWheel() {
        rootView.backgroundColor = .clear
        
        addWedgeView(color: colorPalette.blue, angle: 0, colorId: ColorId.blue)
        addWedgeView(color: colorPalette.black, angle: 0.5 * .pi, colorId: ColorId.black)
        addWedgeView(color: colorPalette.green, angle: .pi, colorId: ColorId.green)
        addWedgeView(color: colorPalette.red, angle: 1.5 * .pi, colorId: ColorId.red)
    }
    
    func addWedgeView(color: UIColor, angle: Radians, colorId: ColorId) {
        let wedgeView = SimonWedgeView(frame: rootView.bounds)
        wedgeView.fillColor = color
        wedgeView.centerAngle = angle
        wedgeView.colorId = colorId
        wedgeView.addGestureRecognizer(setGestureRecognizer())
        wedgeView.layer.applyShadow(color: colorPalette.shadow, alpha: 0.16, x: 0, y: 6, blur: 4, spread: 0)
        
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
    
    // MARK: - Bar Collection
    private func addBar(wedge: SimonWedgeView) {
        let newBar = BarInput(text: "I", colorId: wedge.colorId!)
        
        barList.append(newBar)
        
        barCollection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return barList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "barCell", for: indexPath) as! BarCollectionViewCell
        
        let bar = barList[indexPath.item]
        let textColor = UIColor.init(hex: bar.colorId.rawValue)
        
        cell.label.text = bar.text
        cell.label.textColor = textColor
        
        return cell
    }
}
