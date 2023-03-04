//
//  String+format.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import Foundation

extension String {
    var int: Int? {
        Int(self)
    }
    var sqlToBool: Bool {
        if self == "TRUE" {
            return true
        }
        if self == "FALSE" {
            return false
        }
        DebugPrint("例外情況")
        return false
    }
}
