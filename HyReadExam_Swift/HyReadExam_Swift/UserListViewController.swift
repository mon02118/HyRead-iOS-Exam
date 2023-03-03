//
//  UserListViewController.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/3.
//

import UIKit

class UserListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Service().fetch()
        
        // Do any additional setup after loading the view.
    }


}



struct Service {
    func fetch() {
        let urlString = "https://mservice.ebook.hyread.com.tw/exam/user-list"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        let task = URLSession.shared.dataTask(with: request) { _data, _response, _error in
            if let error = _error {
                print(error)
            }
            if let data = _data {
                let str = String(data: data, encoding: .utf8)
                print(str)
            }
            
        }
        
        task.resume()
    }
}
