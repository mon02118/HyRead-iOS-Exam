//
//  Bool+format.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import Foundation

extension Bool {
    var sqlString: String {
        return self ? "TRUE" : "FALSE"
    }
}
