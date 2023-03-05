//
//  SqlColumn.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import Foundation


struct SqlColumn {
    
    enum SqlDataType {
        case integer
        case text
        
        var sqlText: String {
            switch self {
            case .integer:
                return "INTEGER"
            case .text:
                return "TEXT"
                
            }
        }
    }
    
    let columnName: String
    var dataType: SqlDataType = .text
    var columnOptions: SqlLiteColumnOptions = [.notNull]
}
