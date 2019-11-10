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
    
    let toolKit = UIExtensions()
    
    @IBOutlet var navBar: UIView!
    var textView: UITextView!
    var keyboard: KeyboardView!
    
    
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
        let keyboard = KeyboardView(frame: CGRect(x: 0, y: frame.maxY - (frame.height / 3.0), width: frame.width, height: frame.height / 3.0))
        
        keyboard.addTextViewDelegate(delegate: self)
        
        self.keyboard = keyboard
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupTextView() {
        let padding = 16.0 as CGFloat
        let startingY = navBar.frame.maxY
        
        let frame = CGRect(x: padding, y: startingY, width: view.frame.width - padding * 2, height: view.frame.maxY * (2.0/3.0) - startingY)
        let textView = UITextView(frame: frame)
        textView.backgroundColor = UIColor.white
        
        self.textView = textView
        self.view.addSubview(textView)
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(EditViewController.handleZoom(pinchRecognizer:)))

        textView.addGestureRecognizer(pinchRecognizer)
        textView.attributedText = barText
        textView.inputView = keyboard
        textView.inputView?.autoresizingMask = []
        
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
        let destVC = navControl.topViewController as! MainViewController
        
        removeTrailingWhitespace()
        
        destVC.barText = textView.attributedText
        destVC.barTotal = updateBarTotal()
        destVC.currBarCount = updateBarCount()
    }
}
