//
//  ViewController.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 5/14/18.
//  Copyright © 2018 Liliana Terry. All rights reserved.
//

import UIKit

struct item {
    
}

class ViewController: UIViewController {
    
    var contents = [String]()
    
    // button appearances
    @IBOutlet weak var one: UIButton!
    @IBOutlet weak var two: UIButton!
    @IBOutlet weak var three: UIButton!
    @IBOutlet weak var four: UIButton!
    @IBOutlet weak var five: UIButton!
    @IBOutlet weak var six: UIButton!
    @IBOutlet weak var seven: UIButton!
    
    @IBOutlet weak var red: UIButton!
    @IBOutlet weak var blue: UIButton!
    @IBOutlet weak var green: UIButton!
    @IBOutlet weak var black: UIButton!
    
    @IBOutlet weak var recording_bar: UIView!
    
    let colors = UIExtensions()
    
    func injected() {
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ui()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // if outer buttons are pressed
    @IBAction func red(_ sender: Any) {
        if (red.isSelected) {
            red.isSelected = false
        } else {
            select(sender: red, other1: blue, other2: green, other3: black)
        }
    }
    @IBAction func blue(_ sender: Any) {
        if (blue.isSelected) {
            blue.isSelected = false
        } else {
            select(sender: blue, other1: red, other2: green, other3: black)
        }
    }
    @IBAction func green(_ sender: Any) {
        if (green.isSelected) {
            green.isSelected = false
        } else {
            select(sender: green, other1: blue, other2: red, other3: black)
        }
    }
    @IBAction func black(_ sender: Any) {
        if (black.isSelected) {
            black.isSelected = false
        } else {
            select(sender: black, other1: blue, other2: red, other3: green)
        }
    }
    
    // set this button's view to selected, all others to not
    func select(sender: UIButton, other1: UIButton, other2: UIButton, other3: UIButton) {
        sender.isSelected = true
        other1.isSelected = false
        other2.isSelected = false
        other3.isSelected = false
    }
    
    
    // if center buttons are pressed
    @IBAction func bar(_ sender: Any) {
    }
    @IBAction func equals(_ sender: Any) {
    }
    @IBAction func star(_ sender: Any) {
    }
    @IBAction func question(_ sender: Any) {
    }
    
    // UI Changes
    func ui() {
        add_shadow()
        setupWheel()
    }
    
    // adds drop shadow to all elements
    func add_shadow() {
        one.layer.applyShadow(color: colors.shadow, alpha: 0.16, x: 0, y: 6, blur: 64, spread: 0)
        two.layer.applyShadow(color: colors.shadow, alpha: 0.16, x: 0, y: 6, blur: 64, spread: 0)
        three.layer.applyShadow(color: colors.shadow, alpha: 0.16, x: 0, y: 6, blur: 64, spread: 0)
        four.layer.applyShadow(color: colors.shadow, alpha: 0.16, x: 0, y: 6, blur: 64, spread: 0)
        five.layer.applyShadow(color: colors.shadow, alpha: 0.16, x: 0, y: 6, blur: 64, spread: 0)
        six.layer.applyShadow(color: colors.shadow, alpha: 0.16, x: 0, y: 6, blur: 64, spread: 0)
        seven.layer.applyShadow(color: colors.shadow, alpha: 0.16, x: 0, y: 6, blur: 64, spread: 0)
        
        recording_bar.layer.applyShadow(color: colors.shadow, alpha: 0.16, x: 0, y: 6, blur: 64, spread: 0)
        recording_bar.layer.cornerRadius = recording_bar.frame.height / 2
    }
    
    // changes visual behavior when outer wheel buttons are pressed
    func setupWheel() {
        red.setImage(#imageLiteral(resourceName: "red_selected"), for: .selected)
        red.adjustsImageWhenHighlighted = false
        
        green.setImage(#imageLiteral(resourceName: "green_selected"), for: .selected)
        green.adjustsImageWhenHighlighted = false
        
        blue.setImage(#imageLiteral(resourceName: "blue_selected"), for: .selected)
        blue.adjustsImageWhenHighlighted = false

        black.setImage(#imageLiteral(resourceName: "black_selected"), for: .selected)
        black.adjustsImageWhenHighlighted = false
    }
    



}

