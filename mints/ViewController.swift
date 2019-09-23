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
    
    let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        g.posts.removeAll()
        addSlideMenuButton()
        checkUserStatus()
        configureFirebase()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        
        navigationItem.title = "Mints"
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
            
            let show = snapshot.value as? NSDictionary
            let show_status: String = show?["show"] as? String ?? "true"
            
            /* VIELLEICHT KATEGORIE?
             let newLocation = snapshot.value as? NSDictionary
             let post_location:String = newLocation?["standort"] as? String ?? "Alle"
             */
            
            if show_status == "true" {
                g.posts.append(Post(title: post_title, description: post_description, user: post_user, answers: [], date: post_date))
                print("\(g.posts.count) in posts")
            }
            
            DispatchQueue.main.async() {
                
                self.tableView.reloadData()
            }
        })
        print("-- Firebase setup done (\(g.posts.count) posts found)--")
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        print(g.posts)
        
        
        
        if editingStyle == .delete {
            
            g.posts.remove(at: indexPath.row)
            self.tableView.reloadData()
            
            print(indexPath.row)
            print(g.posts)
        }
        
        let alert = UIAlertController(title: "Notiz löschen?", message: "Gelöschte einträge sind nicht wieder herzustellen und sind für alle wirksam", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Löschen", style: .destructive, handler: { (action) in
            
            g.ref.child(g.posts[indexPath.row].title).setValue(["titel": g.posts[indexPath.row].title, "beschreibung": g.posts[indexPath.row].description, "datum": g.posts[indexPath.row].date, "nutzer": g.posts[indexPath.row].user, "show": "false"])
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
        }))
    }
    
    func checkUserStatus(){
        
        g.loadUsername()
        
        if g.username == "" {
            let user = mainStoryboard.instantiateViewController(withIdentifier: "UserDetailsViewController") as! UserDetailsViewController
            self.navigationController?.pushViewController(user, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        g.question = g.posts[indexPath.row]
        
        let des = mainStoryboard.instantiateViewController(withIdentifier: "DesViewController") as! DesViewController
        self.navigationController?.pushViewController(des, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
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

