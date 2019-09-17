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
    var answers: [String]
    var date: String
}

class Global {
    
    var ref: DatabaseReference! = Database.database().reference()
    
    var posts = [Post]()
    
    var username = ""
    
    func saveUsername(){
        UserDefaults.standard.set(g.username, forKey: "username")
        print("\(g.username) saved as username")
    }
    
    func loadUsername(){
        g.username = UserDefaults.standard.string(forKey: "username")!
        
        if g.username != "" {
            print("Username \(g.username) found")
        } else {
            print("No username found...")
        }
    }
    
}

let g = Global()
