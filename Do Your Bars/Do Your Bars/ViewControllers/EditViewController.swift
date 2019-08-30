//
//  EditViewController.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 1/1/19.
//  Copyright © 2019 Liliana Terry. All rights reserved.
//

import UIKit

protocol TextEditorDelegate: AnyObject {
    func addItem(newItem: String)
    func deleteSelected()
}

class EditViewController: UIViewController, TextEditorDelegate {
    
    var textView: UITextView!
    
    var keyboard: KeyboardView!
    
    let toolKit = UIExtensions()
    
    var barText: NSAttributedString = NSAttributedString()
    
    var currColor: ColorKeyboardButton = ColorKeyboardButton()
    
    var restrictRotation:UIInterfaceOrientationMask = .portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.restrictRotation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        setupKeyboard()
        setupTextView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func setupKeyboard() {
        self.becomeFirstResponder()     // for keyboard
        let frame = self.view.frame
        let keyboard = KeyboardView(frame: CGRect(x: 0, y: frame.maxY - frame.height / 3, width: frame.width, height: frame.height / 3))
        
        keyboard.addTextViewDelegate(delegate: self)
        
        self.keyboard = keyboard
    }

    // TODO: CAN THIS CODE GO?
//    private func setupKeyboard() {
//        self.view.backgroundColor = toolKit.header_background
//        keyboard.backgroundColor = toolKit.header_background
//
//        colorButtons = [redButton, blueButton, greenButton, blackButton]
//        redButton.addColor(color: toolKit.red)
//        blueButton.addColor(color: toolKit.blue)
//        greenButton.addColor(color: toolKit.green)
//        blackButton.addColor(color: toolKit.black)
//
//        currColor = blackButton
//        currColor.select()
//
//        keyboard.removeFromSuperview()
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
//    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // TODO: CAN THIS CODE GO?
//    // edit button corner radius after keyboard has appeared and constrained correctly
//    @objc private func keyboardWillAppear() {
//        let rowStack = keyboard.subviews[0]
//        let rows = rowStack.subviews
//
//        for row in rows {
//            let buttons = row.subviews
//            for subview in buttons {
//                let button = subview as! KeyboardButton
//                button.layer.cornerRadius = button.frame.width / 2
//            }
//        }
//
//        self.view.addSubview(keyboard)
//    }
    
    private func setupTextView() {
        let startingY = (navigationController?.navigationBar.frame.height)! + 30
        let frame = CGRect(x: 0, y: startingY, width: view.frame.width, height: view.bounds.height * (2/3) - startingY)
        let textView = UITextView(frame: frame)
        textView.backgroundColor = UIColor.white
        
        self.textView = textView
        self.view.addSubview(textView)
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(EditViewController.handleZoom(pinchRecognizer:)))

        textView.addGestureRecognizer(pinchRecognizer)
        textView.attributedText = barText
        textView.inputView = keyboard
        
        textView.becomeFirstResponder() // to pull up keyboard immediately
    }
    
    @objc private func handleZoom(pinchRecognizer: UIPinchGestureRecognizer) {
        let scaledSize = toolKit.barSize * pinchRecognizer.scale
        textView.font = UIFont.boldSystemFont(ofSize: scaledSize)
    }
    
    @IBAction func cancelSelected(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func saveSelected(_ sender: Any) {
        performSegue(withIdentifier: "saveSegue", sender: self)
    }
    
    func addItem(newItem: String) {
        let size = textView.font != nil ? textView.font!.pointSize : toolKit.barSize
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: size),
            .foregroundColor: keyboard.currColor as Any,
        ]
        let item = NSMutableAttributedString(string: newItem, attributes: attributes)
        
        var currString = textView.attributedText.mutableCopy() as! NSMutableAttributedString
        let selection = textView.selectedRange
        
        if (selection.length > 0) {
            currString = deleteRange(range: selection)
        }
        
        currString.insert(item, at: selection.lowerBound)
        textView.attributedText = currString
        
        let newSelection = NSMakeRange(selection.lowerBound + 1, 0)
        textView.selectedRange = newSelection
    }
    
    func deleteSelected() {
        let selection = textView.selectedRange
        deleteRange(range: selection)
    }
    
    @discardableResult private func deleteRange(range: NSRange) -> NSMutableAttributedString {
        let currString = textView.attributedText.mutableCopy() as! NSMutableAttributedString
        
        var deletionRange = range
        if range.length == 0 && range.lowerBound != 0 {
            deletionRange = NSMakeRange(range.lowerBound - 1, 1)
        }
        
        currString.deleteCharacters(in: deletionRange)
        textView.attributedText = currString
        
        let cursorPos = range.lowerBound > 0 ? NSMakeRange(range.lowerBound - 1, 0) : NSMakeRange(0, 0)
        textView.selectedRange = cursorPos
        
        return textView.attributedText.mutableCopy() as! NSMutableAttributedString
    }
    
    @IBAction func insertSpace(_ sender: Any) {
        let index = textView.selectedRange.lowerBound
        let currString = textView.attributedText.mutableCopy() as! NSMutableAttributedString
        
        currString.insert(toolKit.space, at: index)
        textView.attributedText = currString
        textView.selectedRange = NSMakeRange(index + toolKit.space.length, 0)
    }
    
    @IBAction func selectColor(_ sender: Any) {
        let button = sender as! ColorKeyboardButton
        
        if (currColor != button) {
            currColor.deselect()
            currColor = button
            currColor.select()
        }
    }
    
    private func updateBarTotal() -> Float {
        var total: Float = 0
        let finalString = textView.text!
        
        for char in finalString {
            if (char == "I") {
                total += 1
            } else {
                let charStr = String(char)
                if (charStr.isNumber) {
                    total += Float(charStr)! / 8
                }
            }
        }
        
        return total
    }
    
    private func updateBarCount() -> Int {
        var index = textView.text.count - 1
        guard index >= 0 else { return 0 }
        
        let text = textView.attributedText as NSAttributedString
        var currChar = text.last()
        var currColor = text.attribute(.foregroundColor, at: index, effectiveRange: nil) as! UIColor
        let color = currColor

        var count = 0
        while (color == currColor && index > 0 && count < 4 && currChar.string != "=") {
            index -= 1
            count += 1
            
            currChar = text.attributedSubstring(from: NSMakeRange(index, 1))
            if (currChar.string == " ") {
                break
            }
            currColor = text.attribute(.foregroundColor, at: index, effectiveRange: nil) as! UIColor
        }
        
        return count
    }
    
    private func removeTrailingWhitespace() {
        var lastChar = textView.text.suffix(1)
        
        while (lastChar == " ") {
            textView.attributedText = textView.attributedText.removeLast()
            lastChar = textView.text.suffix(1)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navControl = segue.destination as! UINavigationController
        let destVC = navControl.topViewController as! ViewController
        
        removeTrailingWhitespace()
        
        destVC.barText = textView.attributedText
        destVC.barTotal = updateBarTotal()
        destVC.currBarCount = updateBarCount()
    }
}
