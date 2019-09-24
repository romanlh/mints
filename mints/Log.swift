//
//  Log.swift
//  mints
//
//  Created by Roman Häckel on 23.09.19.
//  Copyright © 2019 Roman Häckel. All rights reserved.
//

import Foundation
import os

private let subsystem = "com.romanhckl.mints"

struct Log {
    static let table = OSLog(subsystem: subsystem, category: "table")
    static let user = OSLog(subsystem: subsystem, category: "user")
}
