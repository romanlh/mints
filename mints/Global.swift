//
//  Global.swift
//  mints
//
//  Created by Roman Häckel on 14.09.19.
//  Copyright © 2019 Roman Häckel. All rights reserved.
//

import Foundation
import Firebase

struct Post {
    var title: String
    var description: String
    var user: String
    var answers: [Answer]
    var date: String
}

struct Answer {
    var answer: String
    var user: String
    var time: String
    var date: String
}

class Global {
    
    var ref: DatabaseReference! = Database.database().reference()
    
    var posts = [Post]()
    var answers = [Answer]()
    var question = Post(title: "", description: "", user: "", answers: [], date: "")
    
    let mainColor = UIColor(red: 56, green: 99, blue: 154, alpha: 1)
    let detailColor = UIColor(red: 210, green: 108, blue: 28, alpha: 1)
    
    var username = ""
    
    func saveUsername(){
        UserDefaults.standard.set(g.username, forKey: "username")
        print("\(g.username) saved as username")
    }
    
    func loadUsername(){
        g.username = UserDefaults.standard.string(forKey: "username") ?? ""
        
        if g.username != "" {
            print("Username \(g.username) found")
        } else {
            print("No username found...")
        }
    }
    
}

let g = Global()
