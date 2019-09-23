//
//  UserDetailsViewController.swift
//  mints
//
//  Created by Roman Häckel on 14.09.19.
//  Copyright © 2019 Roman Häckel. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createButton.tintColor = g.detailColor
    }

    @IBAction func saveUsername(_ sender: UIButton) {
        
        g.username = usernameTextField.text!
        
        g.saveUsername()
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let view = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(view, animated: true)
        
    }
    
}
