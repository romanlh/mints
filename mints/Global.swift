//
//  Global.swift
//  mints
//
//  Created by Roman Häckel on 14.09.19.
//  Copyright © 2019 Roman Häckel. All rights reserved.
//

import Foundation

struct Post {
    var title: String
    var description: String
    var user: String
    var answers: [String]
    var date: String
}

class Global {
    
    var posts = [Post]()
    
    var username = ""
    
}

let g = Global()
