//
//  SqlColumn.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import Foundation


struct SqlColumn {
    
    enum SqlDataType {
        case null
        case integer
        case real
        case text
        case blob
        
        var sqlText: String {
            switch self {
            case .blob:
                return "BLOB"
            case .integer:
                return "INTEGER"
            case .null:
                return "NULL"
            case .real:
                return "REAL"
            case .text:
                return "TEXT"
                
            }
        }
    }
    
    let columnName: String
    var dataType: SqlDataType = .text
    var columnOptions: SqlLiteColumnOptions = [.notNull]
}
