//
//  SqlLiteColumnOptions.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import Foundation


struct SqlLiteColumnOptions: OptionSet {
    let rawValue: Int
    
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    static let notNull: SqlLiteColumnOptions = SqlLiteColumnOptions(rawValue: 1 << 0)
    static let primaryKey: SqlLiteColumnOptions = SqlLiteColumnOptions(rawValue: 1 << 1)
    
    func getSqlName() -> String {
        var result = ""
        if self.contains(.primaryKey) {
            result += "PRIMARY KEY "
        }
        if self.contains(.notNull) {
            result += "NOT NULL "
        }
        return result
    }
}
