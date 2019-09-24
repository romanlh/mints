//
//  SwiftLoggor.swift
//  mints
//
//  Created by Roman Häckel on 23.09.19.
//  Copyright © 2019 Roman Häckel. All rights reserved.
//

import Foundation

class SwiftLoggor {
    
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var fileContent = ""
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    class func log(message: String,
        event: ErroTypes,
        fileName: String = #file,
        line: Int = #line,
        column: Int = #column,
        funcName: String = #function) -> String{
        return "\(Date().toString()) \(event.rawValue)[\(sourceFileName(filePath: fileName))]:\(line) \(column)\(funcName) -> \(message)"
    }
    class func writeToFile(message: String){
        let filename = SwiftLoggor.getDocumentsDirectory().appendingPathComponent("Log.txt")
        do {
            try message.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Some error occur")
        }
    }
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension Date {
    func toString() -> String {
        return SwiftLoggor.dateFormatter.string(from: self as Date)
    }
}

enum ErroTypes : String{
    case e = "[‼]" // error
    case i = "[ℹ]" // info
    case d = "[💬]" // debug
    case v = "[🔬]" // verbose
    case w = "[⚠]" // warning
    case s = "[🔥]" // severe
}
