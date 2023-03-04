//
//  ApiService.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import Foundation


enum DemoError: Error {
    case urlFail
    case hasError(String)
    case responseFail
    case decodeFail
    
    
    var msg: String {
        switch self {
        case .urlFail: return "urlFail"
        case .hasError(let msg): return "hasError \(msg)"
        case .responseFail: return "responseFail"
        case .decodeFail: return "decodeFail"
        }
    }
    
}

struct ApiService {
    
    func fetchUserBooklist(completion: @escaping (Result<[UserBookInfoResponse], DemoError>) -> Void ) {
        UserBookRequest().send(completionHandler: completion)
        
    }
}


