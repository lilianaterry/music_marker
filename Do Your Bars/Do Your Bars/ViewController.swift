//
//  ViewController.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 5/14/18.
//  Copyright © 2018 Liliana Terry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
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
        add_shadow()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }
    



}

