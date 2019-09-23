//
//  AnViewController.swift
//  mints
//
//  Created by Roman Häckel on 17.09.19.
//  Copyright © 2019 Roman Häckel. All rights reserved.
//

import UIKit
import Firebase

class AnViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var responseButton: UIButton!
    
    var minuteString: String = ""
    var hourString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func sendAnswer(_ sender: Any) {
        
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        if hour < 10 {
            hourString = "0\(hour)"
        } else {
            hourString = "\(hour)"
        }
        
        if minute < 10 {
            minuteString = "0\(minute)"
        } else {
            minuteString = "\(minute)"
        }
        
        g.ref.child(g.question.title).child("antworten").child(textView.text!).setValue(["antwort": "\(textView.text!)", "zeit": "\(self.hourString):\(self.minuteString)", "nutzer": "\(g.username)", "datum": "\(day).\(month).\(year)"])
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let an = mainStoryboard.instantiateViewController(withIdentifier: "DesViewController") as! DesViewController
        self.navigationController?.pushViewController(an, animated: true)
        
    }
    
}
