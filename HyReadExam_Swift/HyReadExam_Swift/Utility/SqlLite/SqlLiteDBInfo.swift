//
//  SqlLiteDBInfo.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import FMDB

protocol SqlLiteData {
    var sqlValues: [Any?] { get }
}

protocol SqlLiteDBInfo {
    
    // FMDatabase Adapter, 避免使用時要import FMDB
    typealias HyDatabase = FMDatabase
    // 轉回Data Model
    associatedtype D: SqlLiteData
    // 資料表名稱
    var tableName: String { get }
    // columns設定值
    var columns: [SqlColumn]  { get }
    // 讀取SQL_Data 轉回 model
    func convertQueryValuesToData(queryValues: [String]) -> D?
}


extension SqlLiteDBInfo {
    
    typealias OrderByType = SqlLiteManager.OrderByType
    
    var tableName: String { return "\(D.self)_TABLE" }
    
    func getCreateTableScript() -> String {
        var createScript = "CREATE TABLE IF NOT EXISTS \(tableName) ("
        
        for columnInfo in columns {
            createScript += "\n"
            createScript += columnInfo.columnName
            createScript += " "
            createScript += columnInfo.dataType.sqlText
            createScript += " "
            createScript += columnInfo.columnOptions.getSqlName()
            createScript += ","
        }
        createScript = String(createScript.dropLast())
        createScript += "\n"
        createScript += ");"
        return createScript
    }
    
    
    func getSelectAllScript(whereDict: [String: String], orderBy: OrderByType?) -> String {
        var script =
            """
            SELECT *
            FROM \(tableName)
            """
        if !whereDict.isEmpty {
            let whereScript = whereDict.map{ "\($0.key)='\($0.value)'"}.joined(separator: " AND ")
            script += "\nWHERE \(whereScript)"
        }
        
        if let orderBy = orderBy {
            script += "\nORDER BY \(orderBy.script)"
        }
        script += ";"
        return script
    }
    
    
    func getInsertOrReplaceScript() -> String {
        var script =
            """
        INSERT OR REPLACE INTO \(tableName) (
        """
        for columnInfo in columns {
            script += columnInfo.columnName
            script += ","
        }
        script.removeLast()
        script += ") "
        script += "VALUES ("
        for _ in columns {
            script += "?,"
        }
        script.removeLast()
        script += ");"
        
        return script
    }
    
    func getUpdateScript(conditionDict: [String: String], setDict: [String: String]) -> String {
        
        
        let setScript = setDict.map { "\($0.key) = '\($0.value)'" }.joined(separator: ",")
        let conditionScript = conditionDict.map { "\($0.key) = '\($0.value)'" }.joined(separator: ",")
        
        let script = """
                    UPDATE OR ABORT \(tableName)
                    SET \(setScript)
                    WHERE \(conditionScript);
        """
        DebugPrint(script)
        return script
    }
    
    func getDropTableScript() -> String {
        
        let script = "DROP TABLE IF EXISTS \(tableName);"
                    
        return script
    }
}

