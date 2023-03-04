//
//  UserBooklistRequest.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import Foundation


extension ApiService {
    struct UserBooklistRequest: BaseRequest {
        let urlString: String = "/user-list"
        let httpMethod: String = "GET"
    }
}


extension ApiService.UserBooklistRequest {
    
    
    func send(completion: @escaping (Result<[UserBookInfo], DemoError>) -> Void ){
        
        let actionUrlString = baseUrlString + urlString
        
        guard let url = URL(string: actionUrlString) else {
            completion(.failure(.urlFail))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        let task = URLSession.shared.dataTask(with: request) { _data, _response, _error in
            if let error = _error {
                DebugPrint(error)
                completion(.failure(.hasError))
                return
            }
            
            guard let httpResponse = _response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                completion(.failure(.responseFail))
                return
            }
            if let data = _data {
                
                let decoder = JSONDecoder()
                do {
                    let model = try decoder.decode([UserBookInfo].self, from: data)
                    completion(.success(model))
                }
                catch{
                    completion(.failure(.decodeFail))
                }
            }
            
        }
        
        task.resume()
    }
    
    
    
}
