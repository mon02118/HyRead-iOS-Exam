//
//  ApiService.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import Foundation


protocol BaseRequest {
    var baseUrlString: String { get }
}

extension BaseRequest {
    var baseUrlString: String { "https://mservice.ebook.hyread.com.tw/exam" }
}



enum DemoError: Error {
    case urlFail
    case hasError
    case responseFail
    case decodeFail
    
    var msg: String {
        switch self {
        case .urlFail: return "urlFail"
        case .hasError: return "hasError"
        case .responseFail: return "responseFail"
        case .decodeFail: return "decodeFail"
        }
    }
    
}

struct ApiService {
    
    func fetchUserBooklist(completion: @escaping (Result<[UserBookInfoResponse], DemoError>) -> Void ) {
        UserBooklistRequest().send(completion: completion)
    }
}
