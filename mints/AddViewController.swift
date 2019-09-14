//
//  AddViewController.swift
//  mints
//
//  Created by Roman Häckel on 14.09.19.
//  Copyright © 2019 Roman Häckel. All rights reserved.
//

import UIKit
import Firebase

class AddViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var desTextView: UITextView!
    
    var ref: DatabaseReference!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }

    @IBAction func create(_ sender: UIButton) {
        
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        let title: String = titleTextField.text!
        let des: String = desTextView.text!
        
        ref.child(titleTextField.text!).setValue(["titel": title,
                                                 "beschreibung": des,
                                                 "datum": "\(day).\(month).\(year)"])

    }
}