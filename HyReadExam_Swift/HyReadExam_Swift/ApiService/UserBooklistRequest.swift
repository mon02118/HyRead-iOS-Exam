//
//  UserBooklistRequest.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import Foundation

struct UserBookInfoResponse: Codable {
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
}



class UserBookRequest: HyReadRequestBase {
    override var address: String { return "exam/user-list" }
    /// HTTP的Method
    override var method: HttpMethod { return .get }
    /// PostContent
    override var postContentType: PostContentType { return .json }
    
}

