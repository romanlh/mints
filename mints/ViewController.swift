//
//  ViewController.swift
//  mints
//
//  Created by Roman Häckel on 14.09.19.
//  Copyright © 2019 Roman Häckel. All rights reserved.
//

import UIKit
import Firebase

class ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        checkUserStatus()
        configureFirebase()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    @objc func addTapped(){
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let add = mainStoryboard.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        self.navigationController?.pushViewController(add, animated: true)
        
    }
    
    func configureFirebase(){
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        print("Referenz gesetzt")
        
        ////////////////////////////////////////////////////////////////
        
        ref.observe( .childAdded, with: { snapshot in
            
        ////////////////////////////////////////////////////////////////
            
            let date = Date()
            let calendar = Calendar.current
            let day = calendar.component(.day, from: date)
            let month = calendar.component(.month, from: date)
            let year = calendar.component(.year, from: date)
            
            let newPost = snapshot.value as? NSDictionary
            let post_title:String = newPost?["titel"] as? String ?? "Frage kann nicht angezeigt werden"
            
            let newPostDespcrition = snapshot.value as? NSDictionary
            let post_description = newPostDespcrition?["beschreibung"] as? String ?? ""
            
            let newPostDate = snapshot.value as? NSDictionary
            let post_date:String = newPostDate?["datum"] as? String ?? "\(day).\(month).\(year)"
            
            let newPostUser = snapshot.value as? NSDictionary
            let post_user:String = newPostUser?["nutzer"] as? String ?? "Unbekannter Nutzer"
            
            /* VIELLEICHT KATEGORIE?
            let newLocation = snapshot.value as? NSDictionary
            let post_location:String = newLocation?["standort"] as? String ?? "Alle"
            */
            
            g.posts.append(Post(title: post_title, description: post_description, user: post_user, answers: [], date: post_date))
            print("\(g.posts.count) in posts")
            
            DispatchQueue.main.async() {
                
                self.tableView.reloadData()
            }
        })
        print("-- Firebase setup done --")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return g.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        g.posts = g.posts.sorted{ $0.dateFromString > $1.dateFromString  }
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Cell",
            for: indexPath) as! AuteurTableViewCell
        let post = g.posts[indexPath.row]
        cell.bioLabel.text = post.title
        cell.detailLabel.text = "\(post.user) - \(post.date)"
        
        if post.title == "Frage kann nicht angezeigt werden" {
            cell.bioLabel.textColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0)
        }
        
        return cell
    }
    
    func checkUserStatus(){
        
        UserDefaults.standard.string(forKey: "username")
        
        if g.username == "" {
            
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let user = mainStoryboard.instantiateViewController(withIdentifier: "UserDetailsViewController") as! UserDetailsViewController
            self.navigationController?.pushViewController(user, animated: true)
            
        } else {
            
            print("Username gefunden: \(g.username)")
            
        }
        
    }

}

extension Post{
    static  let isoFormatter : ISO8601DateFormatter = {
        let formatter =  ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate,]
        return formatter
    }()
    
    var dateFromString : Date  {
        let  iSO8601DateString = date.components(separatedBy: ".").reversed().joined(separator: ".")
        return  Post.isoFormatter.date(from: iSO8601DateString)!
    }
}

