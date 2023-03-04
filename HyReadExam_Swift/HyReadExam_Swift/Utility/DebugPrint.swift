//
//  DebugPrint.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import Foundation

func DebugPrint( _ values: Any... ,
               file: String = #file,
               function: String = #function,
               line: Int = #line) {
    #if DEBUG
    
//    let stringRepresentation: String = value.debugDescription
    
    let fileURL = NSURL(string: file)?.lastPathComponent ?? "Unknown file"
    let queue = Thread.isMainThread ? "Main" : "Background"
    print("㊙️{\(fileURL)} {\(queue)} \(function)[\(line)]:")
    for value in values {
        print("㊙️  ↪ \(value)")
    }
    print("㊙️ ")
    
    #endif
}
