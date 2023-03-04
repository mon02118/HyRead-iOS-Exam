//
//  RequestBase.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import Foundation


/// Http的方法
enum HttpMethod: String {
    /// Get
    case get = "GET"
}

/// Post內容類型
enum PostContentType {
    /// json
    case json
}


/// Request基底類別
class RequestBase: NSObject {
    
    /// 任務實體
    var task: URLSessionDataTask? = nil
    
    /// 傳送http請求的方式
    var method: HttpMethod { return .get }
    
    /// 採用post的內容格式
    var postContentType: PostContentType { return .json}
    
    /// 請求的Timeout
    var timeoutInterval: TimeInterval { return 15.0 }
    
    deinit { cancel() }
    
    /// 終止
    func cancel() {
        task?.cancel()
        task = nil
    }
}
