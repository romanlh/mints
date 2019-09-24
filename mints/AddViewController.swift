//
//  AddViewController.swift
//  mints
//
//  Created by Roman Häckel on 14.09.19.
//  Copyright © 2019 Roman Häckel. All rights reserved.
//

import UIKit
import Firebase

class AddViewController: BaseViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var desTextView: UITextView!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createButton.tintColor = g.detailColor
        navigationItem.title = "Frage erstellen"
    }
    
    @IBAction func create(_ sender: UIButton) {
        
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        let title: String = titleTextField.text!
        let des: String = desTextView.text!
        
        g.ref.child(titleTextField.text!).setValue(["titel": title, "beschreibung": des, "datum": "\(day).\(month).\(year)", "nutzer": g.username, "show": "true"])
        
        print("Post hinzugefügt: \(g.posts.count) Posts")
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let view = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(view, animated: true)
        
    }
}
