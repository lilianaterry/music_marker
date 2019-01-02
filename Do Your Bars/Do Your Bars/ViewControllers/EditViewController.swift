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
    
    let colorPalette = UIExtensions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.inputView = keyboard
        self.view.backgroundColor = colorPalette.header_background
        keyboard.backgroundColor = colorPalette.header_background
    }

}
