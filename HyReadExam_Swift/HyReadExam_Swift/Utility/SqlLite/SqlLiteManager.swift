//
//  SqlLiteManager.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//
import FMDB

final class SqlLiteManager {
    
    // Singleton 設計
    static let shared = SqlLiteManager()

    /// Queue
    private var contentsQueue = DispatchQueue(label: "SQLiteContentsQueue")
    
    
    private let databaseName: String = "DemoHyRead.db"
    
    private lazy var db: FMDatabase = {
        let fileURL = try? FileManager.default.url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: true).appendingPathComponent(databaseName)
        DebugPrint(fileURL ?? "unknow Path")
        return FMDatabase(url: fileURL)
    }()
    
    private init() {}
    
}



extension SqlLiteManager {
    
    // 排序功能
    enum OrderByType {
        case asc(String)
        case desc(String)
        
        var script: String {
            switch self {
            case .asc(let colume): return "\(colume) ASC"
            case .desc(let colume): return "\(colume) DESC"
            }
        }
        
    }
}

// MARK: - 外部接口
extension SqlLiteManager {
    
    /// insert Data
    func insertSqlLiteDataIntoTable<I: SqlLiteDBInfo, D: SqlLiteData>(_ dbInfo: I, infos: [D?]) {
        insertDataIntoTable(dbInfo: dbInfo, infos: infos)
    }
    
    /// get Data
    func getSqlLiteDataFromTable<I: SqlLiteDBInfo>(_ dbInfo: I, whereDict: [String : String] = [:], orderBy: OrderByType? = nil) -> [I.D] {
        getDataFromTable(dbInfo: dbInfo, whereDict: whereDict, orderBy: orderBy)
    }
    
    func updateSqlLiteData<I: SqlLiteDBInfo>(_ dbInfo: I, conditionDict: [String: String], setDict: [String: String]) {
        updateDataInfoTable(dbInfo: dbInfo, conditionDict: conditionDict, setDict: setDict)
    }
    
    func deleteSqlLiteTable<I: SqlLiteDBInfo>(_ dbInfo: I) {
        deleteTable(dbInfo: dbInfo)
    }
        
}

// MARK: - Database CRUD
private extension SqlLiteManager {
    
    
    func dbExcute(dbName: String, sqlScript: String) {
        do {
            let dbFileURL = try FileManager.default.url(for: .documentDirectory,
                                                        in: .userDomainMask,
                                                        appropriateFor: nil,
                                                        create: true).appendingPathComponent(dbName)
            let db = FMDatabase(url: dbFileURL)
            contentsQueue.async {
                if db.open() {
                    do {
                        try db.executeUpdate(sqlScript, values: nil)
                    } catch {
                        DebugPrint(error)
                    }
                    db.commit()
                    db.close()
                }
            }
        } catch {
            DebugPrint(error)
        }
    }
    
    
    func openDatabaseConnection() -> Bool {
        return db.open()
    }
    
    func createTable<I: SqlLiteDBInfo>(dbInfo: I)  {
        
        contentsQueue.async {
            if self.openDatabaseConnection(){
                let createTableScript = dbInfo.getCreateTableScript()
                DebugPrint(createTableScript)
                do {
                    try self.db.executeUpdate(createTableScript, values: nil)
                    DebugPrint("建立 \(dbInfo.tableName) SQL Table")
                } catch {
                    DebugPrint(error)
                }
                self.db.close()
            }
        }
    }
    
    
    func createTableIfNotExist<I: SqlLiteDBInfo>(_ dbInfo: I) {
        
        if openDatabaseConnection() {
            contentsQueue.sync {
                if !db.tableExists(dbInfo.tableName) {
                    createTable(dbInfo: dbInfo)
                }
            }
            
        }
        
    }
    
    
    func insertDataIntoTable<I: SqlLiteDBInfo>(dbInfo: I, script: String) {
        
        contentsQueue.sync {
            do {
                try db.executeUpdate(script, values: nil)
            } catch {
                DebugPrint(error)
            }
            db.commit()
            db.close()
            
        }
    }
    func insertDataIntoTable<I: SqlLiteDBInfo, TableInfo: SqlLiteData>(dbInfo: I, infos: [TableInfo?]) {
        createTableIfNotExist(dbInfo)
        contentsQueue.sync {
            if self.openDatabaseConnection() {
                db.beginTransaction()
                infos.forEach { info in
                    do {
                        let script = dbInfo.getInsertOrReplaceScript()
                        DebugPrint(script)
                        try db.executeUpdate(script, values: info?.sqlValues.map { $0 ?? "" })
                    } catch {
                        DebugPrint(error)
                    }
                    
                }
                db.commit()
                db.close()
            }
        }
    }
    
    
    
    func updateDataInfoTable<I: SqlLiteDBInfo>(dbInfo: I, conditionDict: [String: String], setDict: [String: String]) {
        createTableIfNotExist(dbInfo)
        contentsQueue.sync {
            if self.openDatabaseConnection() {
                db.beginTransaction()
                do {
                    let script = dbInfo.getUpdateScript(conditionDict: conditionDict, setDict: setDict)
                    try db.executeUpdate(script, values: nil)
                } catch {
                    DebugPrint(error)
                }
                db.commit()
                db.close()
            }
        }
    }
    
    
    
    
    func getDataFromTable<I: SqlLiteDBInfo>(dbInfo: I, whereDict: [String : String], orderBy: OrderByType?) -> [I.D] {
        contentsQueue.sync {
            if openDatabaseConnection() {
                let selectScript = dbInfo.getSelectAllScript(whereDict: whereDict, orderBy: orderBy)
                DebugPrint(selectScript)
                do {
                    let resultSet = try db.executeQuery(selectScript, values: nil)
                    var sqlLiteDataList: [I.D] = []
                    while resultSet.next() {
                        var values: [String] = []
                        for column in dbInfo.columns {
                            if let value = resultSet.string(forColumn: column.columnName) {
                                values.append(value)
                            }
                        }
                        if let sqlLiteData = dbInfo.convertQueryValuesToData(queryValues: values) {
                            sqlLiteDataList.append(sqlLiteData)
                        }
                    }
                    db.close()
                    return sqlLiteDataList
                    
                } catch {
                    DebugPrint(error)
                }
                db.close()
            }
            return []
        }
    }
    
    
   
    
    // Delete Table
    func deleteTable<I: SqlLiteDBInfo>(dbInfo: I) {
        contentsQueue.sync {
            if openDatabaseConnection() {
                let deleteScript = dbInfo.getDropTableScript()
                do {
                    try db.executeUpdate(deleteScript, values: nil)
                    DebugPrint("刪除 \(dbInfo.tableName) SQL Table")
                } catch {
                    DebugPrint(error)
                }
                db.close()
            }
        }
    }
    
    
    // Delete DB
    func deleteDB<I: SqlLiteDBInfo>(_ dbInfo: I) {
        do {
            if let url = db.databaseURL {
                try FileManager.default.removeItem(at: url)
                DebugPrint("刪除DB 成功 path:\(url)")
            }
        } catch {
            DebugPrint("刪除DB 失敗 :\(databaseName)")
        }
    }
    
}


