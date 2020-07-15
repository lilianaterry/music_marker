//
//  TestViewController.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 12/25/18.
//  Copyright © 2018 Liliana Terry. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol Button {
    var wedgePath: UIBezierPath! { get set }
    func addItem(prevChar: NSAttributedString) -> NSMutableAttributedString
}

class MainViewController: UIViewController, NumberButtonDelegate {
    
    var shouldLayoutSubviews: Bool = true
    
    var wheelView: UIView!
    var barView: UIView!
    var barTextView: UITextView!
    var numberButtonView: NumberButtonRowView!
    var totalLabel: UILabel!
    
    let toolKit = UIExtensions()
    
    var barText: NSAttributedString = NSAttributedString() { didSet { updateBarText() } }
    var currBarCount: Int = 0
    var barTotal: Float = 0 { didSet { updateTotalLabel() } }
    
    var innerWheelView: UIView!
    
    var buttonList = Array<Button>()
        
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIExtensions().background
        
        if #available(iOS 13, *) {
            overrideUserInterfaceStyle = .light
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // MARK: - Notification oberserver methods

    @objc func didBecomeActive() {
        let storedState = readCurrentState()
        if (barTextView != nil) {
            barTextView.attributedText = storedState
        }
        print("did become active")
    }

    @objc func willEnterForeground() {
        let storedState = readCurrentState()
        if (barTextView != nil) {
            barTextView.attributedText = storedState
        }
        print("will enter foreground")
    }
    
    override func viewDidLayoutSubviews() {
        if (shouldLayoutSubviews) {
            layoutSubViews()
            shouldLayoutSubviews = false
        }
    }
    
    func layoutSubViews() {
        let externalPadding: CGFloat = 16.0
        let internalPadding: CGFloat = 10.0
        let componentGap: CGFloat = 16.0
        
        let safeTop = self.view.safeAreaInsets.top
        let safeBottom = self.view.safeAreaInsets.bottom
        
        let fontSize: CGFloat = 20.0
        
        var currY: CGFloat = safeTop + externalPadding
        let maxWidth: CGFloat = self.view.bounds.width - (2 * externalPadding)
        let maxHeight: CGFloat = self.view.bounds.height - safeTop - safeBottom - (self.navigationController?.toolbar.frame.height)!
        
        let numberButtonRowViewHeight = (maxWidth - (internalPadding * 6)) / 7.0
        let wheelViewHeight = maxWidth
        let totalNumberLabelHeight = fontSize
        let barViewHeight = maxHeight - numberButtonRowViewHeight - wheelViewHeight - (2 * componentGap) - (2 * externalPadding) - internalPadding - totalNumberLabelHeight
        
        let barViewFrame = CGRect(x: externalPadding, y: currY, width: maxWidth, height: barViewHeight)
        setupBarView(frame: barViewFrame)
        self.view.addSubview(barView)
        currY += barViewHeight + internalPadding
        
        let totalNumberLabelFrame = CGRect(x: externalPadding, y: currY, width: maxWidth, height: totalNumberLabelHeight)
        setupTotalNumberLabel(frame: totalNumberLabelFrame)
        self.view.addSubview(totalLabel)
        currY += totalNumberLabelHeight + componentGap
        
        let wheelViewFrame = CGRect(x: externalPadding, y: currY, width: maxWidth, height: wheelViewHeight)
        setupWheelView(frame: wheelViewFrame)
        self.view.addSubview(wheelView)
        currY += wheelViewHeight + componentGap

        let buttonViewFrame = CGRect(x: externalPadding, y: currY, width: maxWidth, height: numberButtonRowViewHeight)
        setupNumberButtonView(frame: buttonViewFrame)
        self.view.addSubview(numberButtonView)
    }
    
    func setupWheelView(frame: CGRect) {
        wheelView = UIView(frame: frame)
        createSimonWheel()
    }
    
    func setupBarView(frame: CGRect) {
        barView = UIView(frame: frame)
        barView.backgroundColor = UIColor.white
        barTextView = UITextView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        barView.addSubview(barTextView)
        
        let tappedView = UITapGestureRecognizer(target: self, action: #selector(MainViewController.viewTapDetected))
        
        barView.addGestureRecognizer(tappedView)
        barView.layer.applyShadow(color: toolKit.shadow, alpha: 0.16, x: 0, y: 4, blur: 8, spread: 0)
        barView.clipsToBounds = false
        barView.layer.cornerRadius = 10
        barTextView.layer.cornerRadius = 10
        
        barTextView.scrollToTop()
        barTextView.isSelectable = false
        barTextView.isEditable = false
        barTextView.showsHorizontalScrollIndicator = false
        barTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        barTextView.attributedText = barText
    }
    
    func setupTotalNumberLabel(frame: CGRect) {
        totalLabel = UILabel(frame: frame)
        updateTotalLabel()
        totalLabel.textColor = toolKit.header
        totalLabel.font = UIFont(name: "SFProDisplay-Semibold", size: frame.height)
    }
    
    func setupNumberButtonView(frame: CGRect) {
        numberButtonView = NumberButtonRowView(frame: frame)
        numberButtonView.delegate = self
    }
    
    private func updateBarText() {
        barTextView?.attributedText = barText
    }
    
    private func updateTotalLabel() {
        if totalLabel != nil {
            totalLabel.text = toolKit.total + String(barTotal)
        }
    }
    
    // MARK: - Wheel
    private func createSimonWheel() {
        // 1 - Create view for inner buttons
        let innerViewSize = CGSize(width: wheelView.frame.width * 0.36, height: wheelView.frame.height * 0.36)
        let innerFrame = CGRect(origin: wheelView.frame.origin, size: innerViewSize)
        innerWheelView = UIView(frame: innerFrame)
        wheelView.addSubview(innerWheelView)
        innerWheelView.center = wheelView.convert(wheelView.center, to: innerWheelView)
        
        innerWheelView.backgroundColor = .clear
        wheelView.backgroundColor = .clear
        
        // 2 - Add wedge buttons
        addWedgeView(color: toolKit.blue, angle: 0, colorId: ColorId.blue)
        addWedgeView(color: toolKit.black, angle: 0.5 * .pi, colorId: ColorId.black)
        addWedgeView(color: toolKit.green, angle: .pi, colorId: ColorId.green)
        addWedgeView(color: toolKit.red, angle: 1.5 * .pi, colorId: ColorId.red)
        
        // 3 - Add inner buttons
        addSemiCircleShadow()
        addSemiCircleView(clockwise: false, text: "?", textYMultiplier: 3, shadow: false)
        addSemiCircleView(clockwise: true, text: "=", textYMultiplier: 1, shadow: false)
    }
    
    private func addWedgeView(color: UIColor, angle: Radians, colorId: ColorId) {
        let wedgeView = SimonWedgeView(frame: wheelView.bounds)
        wedgeView.fillColor = color
        wedgeView.centerAngle = angle
        wedgeView.colorId = colorId
        wedgeView.addGestureRecognizer(setGestureRecognizer())
        
        wheelView.addSubview(wedgeView)
        buttonList.append(wedgeView)
    }
    
    private func addSemiCircleView(clockwise: Bool, text: String, textYMultiplier: CGFloat, shadow: Bool) {
        let semiCircleView = InnerButtonView(frame: innerWheelView.frame)
        semiCircleView.text = text
        semiCircleView.clockwise = clockwise
        semiCircleView.textYMultiplyer = textYMultiplier
        
        semiCircleView.addGestureRecognizer(setGestureRecognizer())
        
        innerWheelView.addSubview(semiCircleView)
        semiCircleView.center = innerWheelView.convert(innerWheelView.center, to: semiCircleView)
        buttonList.append(semiCircleView)
    }
    
    private func addSemiCircleShadow() {
        let topAndBottom = [InnerButtonView(frame: innerWheelView.frame), InnerButtonView(frame: innerWheelView.frame)]

        topAndBottom[0].clockwise = true
        topAndBottom[1].clockwise = false
        
        for view in topAndBottom {
            view.layer.applyShadow(color: toolKit.shadow, alpha: 0.25, x: 0, y: 4, blur: 12, spread: 0)
            innerWheelView.addSubview(view)
            view.center = innerWheelView.convert(innerWheelView.center, to: view)
        }
    }
    
    private func setGestureRecognizer() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(MainViewController.buttonTapDetected(tapRecognizer:)))
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
        if (button.wedgePath.contains(tapLocation)) {
            (button as! UIControl).animate(button as! UIControl)
            return true
        }
        return false
    }
    
    // MARK: - Bar Collection
    func addBarItem(button: Button) {
        let currString = barTextView.attributedText.mutableCopy() as! NSMutableAttributedString
        let newItem = button.addItem(prevChar: currString.last())
        
        // check if a space is needed
        if barTextView.attributedText.length > 0 {
            let currColor = newItem.attribute(.foregroundColor, at: newItem.length - 1, effectiveRange: nil) as! UIColor
            let prevColor = currString.attribute(.foregroundColor, at: currString.length - 1, effectiveRange: nil) as! UIColor
            
            // add empty space if new color added or four bars of the same color have occured
            if (currColor != prevColor || (currBarCount == 4 && newItem.string != "=")) {
                currString.append(toolKit.space)
                currBarCount = 0
            }
        }
        
        let char = newItem.string
        currBarCount = char != "=" ? currBarCount + 1 : 0
        barTotal = char == "I" ? barTotal + 1 : char.isNumber ? barTotal + (Float(char)! / 8) : barTotal

        currString.append(newItem)
        barTextView.attributedText = currString
        
        writeCurrentState(attributedText: currString.copy() as! NSAttributedString)
        
        barTextView.scrollToBottom()
    }
    
    // MARK - Segue to Edit
    @IBAction func deleteSelectedButton(_ sender: Any) {
        // Declare Alert message
        let dialogMessage = UIAlertController(title: "Clear bars?", message: "This will remove all bars and cannot be undone.", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.deleteSelected()
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    // if use really wants to delete all of the current bars
    private func deleteSelected() {
        barTextView.attributedText = NSAttributedString()
        currBarCount = 0
        barTotal = 0
    }
    
    @IBAction func undoSelected(_ sender: Any) {
        guard barTextView.text.count > 0 else { return }
        let char = barTextView.attributedText.last().string
        currBarCount -= char != "=" ? 1 : 0
        barTotal -= char == "I" ? 1 : char.isNumber ? Float(char)! / 8 : 0
        
        barTextView.attributedText = barTextView.attributedText.removeLast()
        barTextView.attributedText = barTextView.attributedText.removeWhiteSpace()
    }
    
    @IBAction func editSelected(_ sender: Any) {
        performSegue(withIdentifier: "editSegue", sender: self)
    }
    
    @objc public func viewTapDetected() {
        performSegue(withIdentifier: "editSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC : EditViewController = segue.destination as! EditViewController
        destVC.barText = barTextView.attributedText
        destVC.delegate = self
    }
    
    // resize back to default heights
    public func viewControllerDidFinishEditing(vc: EditViewController) {
        let newBarText: NSMutableAttributedString = NSMutableAttributedString()
        
        for (index, char) in barText.string.enumerated() {
            var fontSize: CGFloat
            if (char.isNumber) {
                fontSize = toolKit.numSize
            } else if (char == " ") {
                fontSize = toolKit.spaceSize
            } else {
                fontSize = toolKit.barSize
            }
          
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: fontSize),
                .foregroundColor: barText.attribute(.foregroundColor, at: index, effectiveRange: nil) ?? UIColor.purple,
            ]
            let item: NSAttributedString = NSAttributedString(string: String(char), attributes: attributes)
            newBarText.append(item)
        }
        
        if (!barText.isEqual(to: newBarText)) {
            barText = newBarText
        }
        
        writeCurrentState(attributedText: newBarText.copy() as! NSAttributedString)
            
        barTextView.scrollToBottom()
    }
    
    // Private
    
    private func writeCurrentState(attributedText: NSAttributedString) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<StoredText>(entityName: "StoredText")
        request.predicate = NSPredicate(format: "attributedText != nil")
        
        do {
            let result = try context.fetch(request)
                let previousState = result.last ?? nil
                if (previousState != nil) {
                    previousState?.attributedText = barTextView.attributedText
                } else {
                    let currentState = StoredText(context: context)
                    currentState.attributedText = barTextView.attributedText
                }
        } catch {
            print(error)
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    private func readCurrentState() -> NSAttributedString {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<StoredText>(entityName: "StoredText")
        
        do {
            let result = try context.fetch(request)
            let storedState = result.last ?? nil
            if (storedState != nil) {
                return storedState!.attributedText!
            }
            return NSAttributedString()
        } catch {
            return NSAttributedString()
        }
    }
    
}
