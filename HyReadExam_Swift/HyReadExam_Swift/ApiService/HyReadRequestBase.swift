//
//  HyReadRequestBase.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import Foundation

class HyReadRequestBase: RequestBase {
    
    // 宣告請求做完callback型別
    typealias RequestCompletionBlock = (Data?, URLResponse?, Error?) -> Void
    
    /// 伺服器位址
    var domain: String {
        return "https://mservice.ebook.hyread.com.tw/"
    }
    
    /// API 位址
    var address: String {
        return ""
    }
}



// MARK: - 在主緒上做回調結果
extension HyReadRequestBase {
    
    /// 在主緒上做回調結果
    public func send<T: Decodable>(completionHandler: @escaping (Result<T, DemoError>) -> Void) {
        return sendAsync(domain: domain, completionHandler: { T in DispatchQueue.main.async { completionHandler(T) } })
    }
    
    
}


extension HyReadRequestBase {
    /// 在背景執行緒上做回調結果
    private func sendAsync<T: Decodable>(domain: String, completionHandler: @escaping (Result<T, DemoError>) -> Void) {
        switch method {
        case .get:
            task = requestWithUrl(urlString: domain + address, method: .get, timeoutInterval: timeoutInterval, completion: { (data, response, error) in
                self.receiveHandler(data: data, response: response, error: error, completionHandler: completionHandler)
            })
    
        }
    }
    func requestWithUrl(urlString: String, method: HttpMethod, timeoutInterval: TimeInterval, completion: RequestCompletionBlock?) -> URLSessionDataTask? {
        guard let queryedURL = URL(string: urlString) else { return nil}
        
        DebugPrint("🌐 [\(method.rawValue) Url]: \(queryedURL)")
        var request = URLRequest(url: queryedURL)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeoutInterval
        switch postContentType {
        case .json: request.addValue("application/json", forHTTPHeaderField: "Content-type")
        }
        return fetchedDataByDataTask(from: request, completion: completion)
    }
    
    /// 收到訊息處理
    private func receiveHandler<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, completionHandler: @escaping (Result<T, DemoError>) -> Void) {
        if let error = error as? NSError{
            completionHandler(.failure(.hasError(error.localizedDescription)))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode)
        else {
            completionHandler(.failure(.responseFail))
            return
        }
        
        if let data = data {
            DebugPrint("📦 [Receive Data]: " + (String(data: data, encoding: .utf8) ?? "No Utf8 Data.(無法解析!!)"))
            if let model = data.jsonDecoder(type: T.self) {
                completionHandler(.success(model))
                DebugPrint("Fetch Success.")
            } else {
                completionHandler(.failure(.decodeFail))
            }
            
            return
        }
        
    }
    
    
    // 非同步取得資料
    private func fetchedDataByDataTask(from request: URLRequest, completion: RequestCompletionBlock?) -> URLSessionDataTask {

        if let httpBody = request.httpBody{
            DebugPrint("🔥 [Parameter]: " + (String(data: httpBody, encoding: .utf8) ?? "No Utf8 Data.(無法解析!!)"))
        }
        // 計算request時間用
        let startDate = Date()

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
           var executionTime = Date().timeIntervalSince(startDate)
           executionTime = Double(round(1000 * executionTime) / 1000)
           DebugPrint("⏰ [Receive Time]: \(executionTime)s - \(request.url?.absoluteString.removingPercentEncoding ?? "")")
           completion?(data, response, error)
        }
        task.resume()
        return task
    }
}
