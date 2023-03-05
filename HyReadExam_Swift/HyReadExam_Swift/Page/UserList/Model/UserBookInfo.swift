//
//  UserBookInfo.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import Foundation

struct UserBookInfo: Codable {
    ///唯一碼
    let uuid: Int
    ///書封圖片
    let coverUrl: String
    ///出版日期
    let publishDate: String
    ///出版社
    let publisher: String
    ///作者
    let author: String
    ///書名
    let title: String
    ///是否收藏
    var isFavorite: Bool = false
    
    
    
    init(uuid: Int, coverUrl: String, publishDate: String, publisher: String, author: String, title: String) {
        self.uuid = uuid
        self.coverUrl = coverUrl
        self.publishDate = publishDate
        self.publisher = publisher
        self.author = author
        self.title = title
    }
    
    
    init?(queryValues: [String]) {
        guard let uuid = queryValues.getElement(0)?.int,
            let coverUrl = queryValues.getElement(1),
            let publishDate = queryValues.getElement(2),
            let publisher = queryValues.getElement(3),
            let author = queryValues.getElement(4),
            let title = queryValues.getElement(5),
            let isFavorite = queryValues.getElement(6)?.sqlToBool else { return nil }
        
        
        self.uuid = uuid
        self.coverUrl = coverUrl
        self.publishDate = publishDate
        self.publisher = publisher
        self.author = author
        self.title = title
        self.isFavorite = isFavorite
    }
    
}



extension UserBookInfo: SqlLiteData {
    var sqlValues: [Any?]  {
        [uuid, coverUrl, publishDate, publisher, author, title, isFavorite.sqlString]
    }
}

struct UserBookInfoDB: SqlLiteDBInfo {

    
    
    typealias D = UserBookInfo
    var columns: [SqlColumn] = [
        .init(columnName: "UUID", dataType: .integer, columnOptions: .primaryKey),
        .init(columnName: "COVERURL"),
        .init(columnName: "PUBLISHDATE"),
        .init(columnName: "PUBLISHER"),
        .init(columnName: "AUTHOR"),
        .init(columnName: "TITLE"),
        .init(columnName: "IS_FAVORITE"),
    ]
    
    func convertQueryValuesToData(queryValues: [String]) -> UserBookInfo? {
        UserBookInfo(queryValues: queryValues)
    }
    
    
}



