//
//  DesViewController.swift
//  mints
//
//  Created by Roman Häckel on 17.09.19.
//  Copyright © 2019 Roman Häckel. All rights reserved.
//

import UIKit
import Firebase

class DesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        titleLabel.text = g.question.title
        tableView.reloadData()
        configureFirebase()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(answer))
        navigationItem.title = "Frage von \(g.question.user)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        g.answers.removeAll()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*
         
         if nutzername == Name des Verfassers {
         
         AnViewController anzeigen
         Antwortentext in textView eingeben
         
         */
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func configureFirebase(){
        
        print("Firebase configuration startet")
        
        print(g.ref!)
        
        g.ref.child("\(g.question.title)").child("antworten").observe( .childAdded, with: { snapshot2 in
            
            let title = snapshot2.value as? NSDictionary
            let a_title:String = title?["antwort"] as? String ?? "Anwort kann nicht angezeigt werden"
            
            let date = snapshot2.value as? NSDictionary
            let a_date:String = date?["datum"] as? String ?? ""
            
            let user = snapshot2.value as? NSDictionary
            let a_user:String = user?["nutzer"] as? String ?? ""
            
            let time = snapshot2.value as? NSDictionary
            let a_time:String = time?["zeit"] as? String ?? ""
            
            g.answers.append(Answer(answer: a_title, user: a_user, time: a_time, date: a_date))
            
            print(g.answers.count)
            
            DispatchQueue.main.async() {
                
                self.tableView.reloadData()
            }
        })
    }
    
    @objc func answer(){
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let an = mainStoryboard.instantiateViewController(withIdentifier: "AnViewController") as! AnViewController
        self.navigationController?.pushViewController(an, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return g.answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("Cell building startet")
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Cell",
            for: indexPath) as! AuteurTableViewCell

        let answer = g.answers[indexPath.row]
        cell.bioLabel.text = answer.answer
        cell.detailLabel.text = "\(answer.user) - \(answer.time) \(answer.date)"
        
        print("Cell building ended")
        return cell
    }
}
