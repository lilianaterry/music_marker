//
//  AlertViewController.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 10/6/20.
//  Copyright © 2020 Liliana Terry. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    var track: UITextField!
    var artist: UITextField!
    var length: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func CreateFormViewController() -> UIViewController {
        let alert = UIAlertController(title: "Track details", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel" , style: .cancel)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) -> Void in
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Name"
            self.track = textField
        })
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Artist"
            self.artist = textField
        })
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Length"
            self.length = textField
        })
        
        return self
    }
}
