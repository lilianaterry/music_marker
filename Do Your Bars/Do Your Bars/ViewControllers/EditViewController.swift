//
//  EditViewController.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 1/1/19.
//  Copyright © 2019 Liliana Terry. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var keyboard: UIView!
    
    let toolKit = UIExtensions()
    
    var barText: NSAttributedString = NSAttributedString()
    var currColor: UIColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        currColor = toolKit.black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupButtons()
    }
    
    private func setupViews() {
        self.view.backgroundColor = toolKit.header_background
        keyboard.backgroundColor = toolKit.header_background
        
        keyboard.removeFromSuperview()

        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(EditViewController.handleZoom(pinchRecognizer:)))
        textView.inputView = keyboard
        textView.addGestureRecognizer(pinchRecognizer)
        textView.attributedText = barText
    }
    
    private func setupButtons() {
        let innerStack = keyboard.subviews[0]
        for subview in innerStack.subviews {
            for button in subview.subviews {
                button.layer.cornerRadius = button.frame.width / 2
            }
        }
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
    
    @IBAction func addItem(_ sender: CharKeyboardButton) {
        let newItem = sender.addItem(color: currColor)
        var currString = textView.attributedText.mutableCopy() as! NSMutableAttributedString
        let selection = textView.selectedRange
        
        if (selection.length > 0) {
            currString = deleteRange(range: selection)
        }
        
        currString.insert(newItem, at: selection.lowerBound)
        textView.attributedText = currString
        
        let newSelection = NSMakeRange(selection.lowerBound + 1, 0)
        textView.selectedRange = newSelection
    }
    
    @IBAction func deleteItem(_ sender: Any) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navControl = segue.destination as! UINavigationController
        let destVC = navControl.topViewController as! ViewController
        destVC.barText = textView.attributedText
        destVC.currBarCount = 4
    }

}
