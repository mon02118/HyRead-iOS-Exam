//
//  HyReadExam_SwiftTests.swift
//  HyReadExam_SwiftTests
//
//  Created by AddA on 2023/3/3.
//

import XCTest
@testable import HyReadExam_Swift

final class HyReadExam_SwiftTests: XCTestCase {

    func test_fetchUserBooklist() {
        ApiService().fetchUserBooklist { result in
            switch result {
            case .success(let response): XCTAssertFalse(response.isEmpty)
            case .failure(let error): XCTFail(error.msg)
            }
        }
    }
    
    
    func test_UserBookInfoResponse () {
        let responseStr = """
        {
          "uuid": 72,
          "title": "國家公園 2010.03 春季刊:美景動人 文宣入心",
          "coverUrl": "https://webcdn2.ebook.hyread.com.tw/bookcover/1316820124811040516.JPG",
          "publishDate": "2010.03",
          "publisher": "內政部營建署",
          "author": "內政部營建署"
        }
"""
        let data = responseStr.data(using: .utf8)
        if let model = data?.jsonDecoder(type: UserBookInfoResponse.self) {
            XCTAssertEqual(model.uuid, 72)
            XCTAssertEqual(model.title, "國家公園 2010.03 春季刊:美景動人 文宣入心")
            XCTAssertEqual(model.coverUrl, "https://webcdn2.ebook.hyread.com.tw/bookcover/1316820124811040516.JPG")
            XCTAssertEqual(model.publishDate, "2010.03")
            XCTAssertEqual(model.publisher, "內政部營建署")
            XCTAssertEqual(model.author, "內政部營建署")
        } else {
            XCTFail("model can't decode")
        }
        
        
    }
    
    
    func test_UserBookInfo () {
        let queryValues = ["72",
                           "https://webcdn2.ebook.hyread.com.tw/bookcover/1316820124811040516.JPG",
                           "2010.03",
                           "內政部營建署",
                           "內政部營建署",
                           "國家公園 2010.03 春季刊:美景動人 文宣入心",
                           "TRUE"]
        guard let model = UserBookInfo(queryValues: queryValues) else { return }
        
        XCTAssertEqual(model.uuid, 72)
        XCTAssertEqual(model.title, "國家公園 2010.03 春季刊:美景動人 文宣入心")
        XCTAssertEqual(model.coverUrl, "https://webcdn2.ebook.hyread.com.tw/bookcover/1316820124811040516.JPG")
        XCTAssertEqual(model.publishDate, "2010.03")
        XCTAssertEqual(model.publisher, "內政部營建署")
        XCTAssertEqual(model.author, "內政部營建署")
        XCTAssertEqual(model.isFavorite, true)
        let queryValues2 = ["72",
                           "https://webcdn2.ebook.hyread.com.tw/bookcover/1316820124811040516.JPG",
                           "2010.03",
                           "內政部營建署",
                           "內政部營建署",
                           "國家公園 2010.03 春季刊:美景動人 文宣入心",
                           "FALSE"]
        guard let model = UserBookInfo(queryValues: queryValues2) else { return }
        
        XCTAssertEqual(model.uuid, 72)
        XCTAssertEqual(model.title, "國家公園 2010.03 春季刊:美景動人 文宣入心")
        XCTAssertEqual(model.coverUrl, "https://webcdn2.ebook.hyread.com.tw/bookcover/1316820124811040516.JPG")
        XCTAssertEqual(model.publishDate, "2010.03")
        XCTAssertEqual(model.publisher, "內政部營建署")
        XCTAssertEqual(model.author, "內政部營建署")
        XCTAssertEqual(model.isFavorite, false)
        
    }
    
    
    
    
    

}
